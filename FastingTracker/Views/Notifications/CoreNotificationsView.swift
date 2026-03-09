import SwiftUI
import UserNotifications

struct CoreNotificationsView: View {
    @State private var notificationPermissionStatus: UNAuthorizationStatus = .notDetermined
    @State private var upcomingNotifications: [UNNotificationRequest] = []
    
    var body: some View {
        NavigationStack {
            List {
                Section("Notification Settings") {
                    notificationStatusView
                }
                
                Section("Upcoming Notifications") {
                    if upcomingNotifications.isEmpty {
                        HStack {
                            Image(systemName: "bell.slash")
                                .foregroundStyle(.secondary)
                            Text("No upcoming notifications")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 8)
                    } else {
                        ForEach(upcomingNotifications, id: \.identifier) { notification in
                            CoreNotificationRowView(notification: notification)
                        }
                    }
                }
            }
            .navigationTitle("Notifications")
            .refreshable {
                await updateNotificationStatus()
            }
        }
        .onAppear {
            Task {
                await updateNotificationStatus()
            }
        }
    }
    
    @ViewBuilder
    private var notificationStatusView: some View {
        switch notificationPermissionStatus {
        case .notDetermined:
            Button("Enable Notifications") {
                NotificationManager.shared.requestAuthorization()
                Task {
                    await updateNotificationStatus()
                }
            }
            .foregroundStyle(.blue)
            
        case .denied:
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "bell.slash.fill")
                        .foregroundStyle(.red)
                    Text("Notifications Disabled")
                        .font(.headline)
                }
                
                Text("Enable notifications in Settings to receive fasting reminders and milestone alerts.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Button("Open Settings") {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }
                .font(.caption)
                .foregroundStyle(.blue)
            }
            .padding(.vertical, 4)
            
        case .authorized, .provisional, .ephemeral:
            HStack {
                Image(systemName: "bell.fill")
                    .foregroundStyle(.green)
                Text("Notifications Enabled")
                    .font(.headline)
                Spacer()
                Text("✓")
                    .foregroundStyle(.green)
                    .font(.title2)
            }
            
        @unknown default:
            Text("Unknown notification status")
                .foregroundStyle(.secondary)
        }
    }
    
    private func updateNotificationStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        await MainActor.run {
            notificationPermissionStatus = settings.authorizationStatus
        }
        
        let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        await MainActor.run {
            upcomingNotifications = requests
        }
    }
}

struct CoreNotificationRowView: View {
    let notification: UNNotificationRequest
    
    private var triggerDate: Date? {
        if let trigger = notification.trigger as? UNCalendarNotificationTrigger {
            return trigger.nextTriggerDate()
        }
        return nil
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(notification.content.title)
                .font(.headline)
                .lineLimit(1)
            
            Text(notification.content.body)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            if let date = triggerDate {
                HStack {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text(date, format: .dateTime.weekday(.wide).month().day().hour().minute())
                        .font(.caption2)
                }
                .foregroundStyle(.blue)
                .padding(.top, 2)
            }
        }
        .padding(.vertical, 2)
    }
}