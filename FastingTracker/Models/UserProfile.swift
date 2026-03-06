import Foundation
import SwiftData

@Model
final class UserProfile {
    var displayName: String
    var avatarEmoji: String
    var fastingGoalHours: Double
    var weeklyGoalDays: Int
    var notificationsEnabled: Bool
    var shareWithFriends: Bool
    var createdAt: Date
    var totalFastsCompleted: Int
    var longestFastHours: Double
    var currentStreak: Int
    var bestStreak: Int

    init(
        displayName: String = "",
        avatarEmoji: String = "🧑",
        fastingGoalHours: Double = 16,
        weeklyGoalDays: Int = 5
    ) {
        self.displayName = displayName
        self.avatarEmoji = avatarEmoji
        self.fastingGoalHours = fastingGoalHours
        self.weeklyGoalDays = weeklyGoalDays
        self.notificationsEnabled = true
        self.shareWithFriends = true
        self.createdAt = Date()
        self.totalFastsCompleted = 0
        self.longestFastHours = 0
        self.currentStreak = 0
        self.bestStreak = 0
    }
}
