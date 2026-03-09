import Foundation
import SwiftData
import SwiftUI
import Observation

@Observable
final class FastingManager {
    var activeFast: FastingSession?
    var elapsedTime: TimeInterval = 0
    var isFastPendingEnd: Bool = false
    var isActive: Bool { activeFast?.isActive ?? false }

    private var timer: Timer?
    private var modelContext: ModelContext?

    var elapsedHours: Double {
        elapsedTime / 3600
    }

    var progress: Double {
        guard let fast = activeFast, fast.targetHours > 0 else { return 0 }
        return min(elapsedHours / fast.targetHours, 1.0)
    }

    var currentStage: CoreFastingStage {
        CoreFastingStage.currentStage(forElapsedHours: elapsedHours)
    }

    var nextStage: CoreFastingStage? {
        CoreFastingStage.nextStage(forElapsedHours: elapsedHours)
    }

    var formattedElapsedTime: String {
        let total = Int(elapsedTime)
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    func configure(modelContext: ModelContext) {
        guard self.modelContext == nil else { return }
        self.modelContext = modelContext
        loadActiveFast()
    }

    func loadActiveFast() {
        guard let modelContext else { return }
        let descriptor = FetchDescriptor<FastingSession>(
            predicate: #Predicate { $0.isActive },
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        activeFast = try? modelContext.fetch(descriptor).first
        if activeFast != nil {
            updateElapsedTime()
            startTimer()
        }
    }

    func startFast(targetHours: Double, mood: String) {
        guard let modelContext else {
            #if DEBUG
            print("❌ Cannot start fast: ModelContext not available")
            #endif
            return
        }

        // Validate inputs
        guard targetHours > 0 && targetHours <= 168 else { // Max 7 days
            #if DEBUG
            print("❌ Invalid target hours: \(targetHours)")
            #endif
            return
        }

        guard !mood.isEmpty else {
            #if DEBUG
            print("❌ Mood cannot be empty")
            #endif
            return
        }

        // Check if there's already an active fast
        if let existingFast = activeFast, existingFast.isActive {
            #if DEBUG
            print("⚠️ There's already an active fast. End it first.")
            #endif
            return
        }

        do {
            let session = FastingSession(targetHours: targetHours, mood: mood)
            modelContext.insert(session)
            try modelContext.save()

            activeFast = session
            elapsedTime = 0
            startTimer()

            NotificationManager.shared.scheduleFastingNotifications(
                startDate: session.startDate,
                targetHours: targetHours
            )

            #if DEBUG
            print("✅ Fast started successfully: \(targetHours)h goal")
            #endif
        } catch {
            #if DEBUG
            print("❌ Failed to start fast: \(error.localizedDescription)")
            #endif
        }
    }

    // MARK: - End Fast Lifecycle

    /// Stops the timer and flags the fast as pending review (save or discard).
    /// The activeFast session remains in memory; nothing is saved yet.
    func stopFastForReview() {
        guard activeFast?.isActive == true else { return }
        stopTimer()
        isFastPendingEnd = true
    }

    /// User changed their mind — resume the fast from where they left off.
    func resumeFast() {
        guard isFastPendingEnd, activeFast != nil else { return }
        isFastPendingEnd = false
        updateElapsedTime()
        startTimer()
    }

    /// Persist the completed fast and update profile stats.
    func confirmSaveFast(notes: String = "") {
        guard let modelContext, let fast = activeFast else { return }
        do {
            fast.endDate = Date()
            fast.isActive = false
            if !notes.isEmpty { fast.notes = notes }
            try modelContext.save()

            elapsedTime = 0
            isFastPendingEnd = false
            let completedFast = fast
            activeFast = nil

            Task { await NotificationManager.shared.cancelFastingNotifications() }
            updateProfileStats(modelContext: modelContext, completedFast: completedFast)
            #if DEBUG
            print("✅ Fast saved: \(completedFast.formattedElapsedTime)")
            #endif
        } catch {
            #if DEBUG
            print("❌ Failed to save fast: \(error.localizedDescription)")
            #endif
        }
    }

    /// Delete the fast without saving stats.
    func discardFast() {
        guard let modelContext, let fast = activeFast else { return }
        modelContext.delete(fast)
        try? modelContext.save()
        stopTimer()
        elapsedTime = 0
        isFastPendingEnd = false
        activeFast = nil
        Task { await NotificationManager.shared.cancelFastingNotifications() }
        #if DEBUG
        print("🗑️ Fast discarded")
        #endif
    }

    /// Convenience — kept for backward compat with tests.
    func endFast() {
        stopFastForReview()
        confirmSaveFast()
    }

    func updateMood(_ mood: String) {
        guard let modelContext, let fast = activeFast else { return }
        fast.mood = mood
        fast.moodLog.append(MoodEntry(emoji: mood, timestamp: Date()))
        try? modelContext.save()
    }

    func updateStartTime(_ date: Date) {
        guard let modelContext, let fast = activeFast else { return }
        fast.startDate = date
        try? modelContext.save()
        updateElapsedTime()
    }

    func updateTargetHours(_ hours: Double) {
        guard let modelContext, let fast = activeFast else { return }
        fast.targetHours = max(1, hours)
        try? modelContext.save()
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func updateElapsedTime() {
        guard let fast = activeFast, fast.isActive else {
            elapsedTime = 0
            return
        }
        elapsedTime = Date().timeIntervalSince(fast.startDate)
    }

    private func updateProfileStats(modelContext: ModelContext, completedFast: FastingSession) {
        let descriptor = FetchDescriptor<UserProfile>()
        guard let profile = try? modelContext.fetch(descriptor).first else { return }

        profile.totalFastsCompleted += 1

        let hours = completedFast.elapsedHours
        if hours > profile.longestFastHours {
            profile.longestFastHours = hours
        }

        if hours >= completedFast.targetHours * 0.8 {
            profile.currentStreak += 1
            if profile.currentStreak > profile.bestStreak {
                profile.bestStreak = profile.currentStreak
            }
        } else {
            profile.currentStreak = 0
        }

        try? modelContext.save()
    }

    func completedSessions(modelContext: ModelContext) -> [FastingSession] {
        let descriptor = FetchDescriptor<FastingSession>(
            predicate: #Predicate { !$0.isActive },
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
}
