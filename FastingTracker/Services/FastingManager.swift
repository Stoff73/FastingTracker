import Foundation
import SwiftData
import SwiftUI

@Observable
final class FastingManager {
    var activeFast: FastingSession?
    var elapsedTime: TimeInterval = 0
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

    var currentStage: FastingStage {
        FastingStage.currentStage(forElapsedHours: elapsedHours)
    }

    var nextStage: FastingStage? {
        FastingStage.nextStage(forElapsedHours: elapsedHours)
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
        guard let modelContext else { return }

        let session = FastingSession(targetHours: targetHours, mood: mood)
        modelContext.insert(session)
        try? modelContext.save()

        activeFast = session
        elapsedTime = 0
        startTimer()

        NotificationManager.shared.scheduleFastingNotifications(
            startDate: session.startDate,
            targetHours: targetHours
        )
    }

    func endFast() {
        guard let modelContext, let fast = activeFast else { return }

        fast.endFast()
        try? modelContext.save()

        stopTimer()
        elapsedTime = 0
        activeFast = nil

        NotificationManager.shared.cancelFastingNotifications()

        updateProfileStats(modelContext: modelContext, completedFast: fast)
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
