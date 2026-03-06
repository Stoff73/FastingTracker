import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error {
                print("Notification auth error: \(error.localizedDescription)")
            }
        }
    }

    func scheduleFastingNotifications(startDate: Date, targetHours: Double) {
        cancelFastingNotifications()

        // Milestone notifications at each fasting stage
        for stage in FastingStage.stages where stage.hours > 0 && stage.hours <= targetHours {
            let triggerDate = startDate.addingTimeInterval(stage.hours * 3600)
            guard triggerDate > Date() else { continue }

            scheduleNotification(
                id: "stage_\(stage.name)",
                title: "\(stage.emoji) \(stage.name) Stage Reached!",
                body: stage.description,
                date: triggerDate
            )
        }

        // Halfway notification
        let halfwayDate = startDate.addingTimeInterval(targetHours * 1800)
        if halfwayDate > Date() {
            scheduleNotification(
                id: "halfway",
                title: "💪 Halfway There!",
                body: "You're halfway to your \(Int(targetHours))-hour fasting goal. Keep going!",
                date: halfwayDate
            )
        }

        // Target reached notification
        let targetDate = startDate.addingTimeInterval(targetHours * 3600)
        if targetDate > Date() {
            scheduleNotification(
                id: "target_reached",
                title: "🎉 Fasting Goal Reached!",
                body: "Congratulations! You've completed your \(Int(targetHours))-hour fast!",
                date: targetDate
            )
        }

        // Hourly check-in reminders (every 6 hours)
        var checkInHour: Double = 6
        while checkInHour < targetHours {
            let checkInDate = startDate.addingTimeInterval(checkInHour * 3600)
            if checkInDate > Date() {
                let stage = FastingStage.currentStage(forElapsedHours: checkInHour)
                scheduleNotification(
                    id: "checkin_\(Int(checkInHour))",
                    title: "⏱️ \(Int(checkInHour)) Hours Fasting",
                    body: "You're in the \(stage.name) stage. How are you feeling?",
                    date: checkInDate
                )
            }
            checkInHour += 6
        }
    }

    func cancelFastingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func scheduleNotification(id: String, title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
