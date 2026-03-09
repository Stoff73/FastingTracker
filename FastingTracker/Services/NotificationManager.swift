import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    // MARK: - Authorization
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Notification authorization error: \(error.localizedDescription)")
                } else if granted {
                    print("✅ Notification authorization granted")
                } else {
                    print("⚠️ Notification authorization denied")
                }
            }
        }
    }
    
    func checkAuthorizationStatus() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }
    
    // MARK: - Fasting Notifications
    
    func scheduleFastingNotifications(startDate: Date, targetHours: Double) {
        Task {
            let status = await checkAuthorizationStatus()
            guard status == .authorized else {
                print("⚠️ Notifications not authorized, skipping scheduling")
                return
            }
            
            await cancelFastingNotifications()
            await scheduleMilestoneNotifications(startDate: startDate, targetHours: targetHours)
            await scheduleTargetReachedNotification(startDate: startDate, targetHours: targetHours)
            await scheduleMotivationalNotifications(startDate: startDate, targetHours: targetHours)
        }
    }
    
    private func scheduleMilestoneNotifications(startDate: Date, targetHours: Double) async {
        // Milestone notifications at each fasting stage
        for stage in CoreFastingStage.stages where stage.hours > 0 && stage.hours <= targetHours {
            let triggerDate = startDate.addingTimeInterval(stage.hours * 3600)
            guard triggerDate > Date() else { continue }
            
            await scheduleNotification(
                id: "stage_\(stage.name.replacingOccurrences(of: " ", with: "_"))",
                title: "\(stage.emoji) \(stage.name) Stage Reached!",
                body: stage.description,
                date: triggerDate,
                sound: .default
            )
        }
    }
    
    private func scheduleTargetReachedNotification(startDate: Date, targetHours: Double) async {
        let targetDate = startDate.addingTimeInterval(targetHours * 3600)
        guard targetDate > Date() else { return }
        
        await scheduleNotification(
            id: "target_reached",
            title: "🎉 Fasting Goal Achieved!",
            body: "Congratulations! You've completed your \(Int(targetHours))-hour fast. How are you feeling?",
            date: targetDate,
            sound: .default
        )
    }
    
    private func scheduleMotivationalNotifications(startDate: Date, targetHours: Double) async {
        let quarterPoint = startDate.addingTimeInterval(targetHours * 0.25 * 3600)
        let halfwayPoint = startDate.addingTimeInterval(targetHours * 0.5 * 3600)
        let threeQuarterPoint = startDate.addingTimeInterval(targetHours * 0.75 * 3600)
        
        let motivationalMessages = [
            (quarterPoint, "💪 You're 25% there!", "Keep going strong! Your body is adapting beautifully."),
            (halfwayPoint, "🔥 Halfway milestone!", "Amazing progress! You're in the zone now."),
            (threeQuarterPoint, "⭐ 75% complete!", "You're so close! The finish line is in sight.")
        ]
        
        for (date, title, body) in motivationalMessages {
            guard date > Date() else { continue }
            
            await scheduleNotification(
                id: "motivation_\(date.timeIntervalSince1970)",
                title: title,
                body: body,
                date: date,
                sound: .default
            )
        }
    }
    
    // MARK: - Helper Methods
    
    func cancelFastingNotifications() async {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("🔕 All fasting notifications cancelled")
    }
    
    private func scheduleNotification(
        id: String,
        title: String,
        body: String,
        date: Date,
        sound: UNNotificationSound = .default
    ) async {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        content.categoryIdentifier = "FASTING_UPDATE"
        
        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: date
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        do {
            try await UNUserNotificationCenter.current().add(request)
            print("📅 Scheduled notification: \(title) for \(date)")
        } catch {
            print("❌ Failed to schedule notification: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Daily Reminders
    
    func scheduleDailyReminder(hour: Int, minute: Int) async {
        let status = await checkAuthorizationStatus()
        guard status == .authorized else { return }
        
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "🌅 Ready to Fast?"
        content.body = "Consider starting your daily fast to maintain your healthy routine."
        content.sound = .default
        content.categoryIdentifier = "DAILY_REMINDER"
        
        let request = UNNotificationRequest(
            identifier: "daily_reminder",
            content: content,
            trigger: trigger
        )
        
        do {
            try await UNUserNotificationCenter.current().add(request)
            print("📅 Daily reminder scheduled for \(hour):\(String(format: "%02d", minute))")
        } catch {
            print("❌ Failed to schedule daily reminder: \(error.localizedDescription)")
        }
    }
    
    func cancelDailyReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily_reminder"])
        print("🔕 Daily reminder cancelled")
    }
    
    // MARK: - Notification Categories
    
    func setupNotificationCategories() {
        let checkInAction = UNNotificationAction(
            identifier: "CHECK_IN",
            title: "How are you feeling?",
            options: []
        )
        
        let fastingCategory = UNNotificationCategory(
            identifier: "FASTING_UPDATE",
            actions: [checkInAction],
            intentIdentifiers: [],
            options: []
        )
        
        let reminderCategory = UNNotificationCategory(
            identifier: "DAILY_REMINDER",
            actions: [],
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([
            fastingCategory,
            reminderCategory
        ])
    }
}
