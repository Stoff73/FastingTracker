import Foundation
import SwiftData

@Model
final class FastingSession {
    var startDate: Date
    var endDate: Date?
    var targetHours: Double
    var mood: String
    var isActive: Bool
    var moodLog: [MoodEntry]
    var notes: String

    init(startDate: Date = Date(), targetHours: Double = 16, mood: String = "😊") {
        self.startDate = startDate
        self.endDate = nil
        self.targetHours = targetHours
        self.mood = mood
        self.isActive = true
        self.moodLog = [MoodEntry(emoji: mood, timestamp: startDate)]
        self.notes = ""
    }
    
    convenience init(targetHours: Double, mood: String) {
        self.init(startDate: Date(), targetHours: targetHours, mood: mood)
    }

    var elapsedTime: TimeInterval {
        let end = endDate ?? Date()
        return end.timeIntervalSince(startDate)
    }

    var elapsedHours: Double {
        elapsedTime / 3600
    }

    var progress: Double {
        min(elapsedHours / targetHours, 1.0)
    }

    var targetDate: Date {
        startDate.addingTimeInterval(targetHours * 3600)
    }

    var currentStage: CoreFastingStage {
        CoreFastingStage.currentStage(forElapsedHours: elapsedHours)
    }

    var formattedElapsedTime: String {
        let total = Int(elapsedTime)
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    var durationDescription: String {
        let hours = Int(elapsedHours)
        let minutes = Int((elapsedHours - Double(hours)) * 60)
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    func endFast() {
        endDate = Date()
        isActive = false
    }
}
