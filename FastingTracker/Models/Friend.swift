import Foundation
import SwiftData

@Model
final class Friend {
    var name: String
    var avatarEmoji: String
    var phoneNumber: String
    var isFasting: Bool
    var fastingStartDate: Date?
    var fastingTargetHours: Double
    var isAuthorizedToView: Bool
    var addedAt: Date

    init(
        name: String,
        avatarEmoji: String = "🧑",
        phoneNumber: String = "",
        isAuthorizedToView: Bool = true
    ) {
        self.name = name
        self.avatarEmoji = avatarEmoji
        self.phoneNumber = phoneNumber
        self.isFasting = false
        self.fastingStartDate = nil
        self.fastingTargetHours = 16
        self.isAuthorizedToView = isAuthorizedToView
        self.addedAt = Date()
    }

    var elapsedHours: Double {
        guard isFasting, let start = fastingStartDate else { return 0 }
        return Date().timeIntervalSince(start) / 3600
    }

    var progress: Double {
        guard fastingTargetHours > 0 else { return 0 }
        return min(elapsedHours / fastingTargetHours, 1.0)
    }

    var formattedElapsed: String {
        let hours = Int(elapsedHours)
        let minutes = Int((elapsedHours - Double(hours)) * 60)
        return "\(hours)h \(minutes)m"
    }
}
