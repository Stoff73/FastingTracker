import SwiftUI

struct NotificationsView: View {
    @State private var notifications: [FastingNotification] = FastingNotification.sampleNotifications
    @State private var notificationsEnabled = true

    var body: some View {
        NavigationStack {
            Group {
                if notifications.isEmpty {
                    emptyState
                } else {
                    notificationsList
                }
            }
            .navigationTitle("Notifications")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        notifications.removeAll()
                    } label: {
                        Text("Clear All")
                            .font(.subheadline)
                    }
                    .disabled(notifications.isEmpty)
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.fill")
                .font(.system(size: 60))
                .foregroundStyle(.cyan.opacity(0.6))

            Text("No Notifications")
                .font(.title2)
                .fontWeight(.semibold)

            Text("You'll receive updates about your fasting milestones, friend activity, and helpful tips here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }

    private var notificationsList: some View {
        List {
            ForEach(notifications) { notification in
                NotificationRow(notification: notification)
            }
            .onDelete { indexSet in
                notifications.remove(atOffsets: indexSet)
            }
        }
    }
}

// MARK: - Notification Model

struct FastingNotification: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let emoji: String
    let timestamp: Date
    let type: NotificationType
    var isRead: Bool = false

    enum NotificationType {
        case milestone
        case friendActivity
        case tip
        case reminder
    }

    static var sampleNotifications: [FastingNotification] {
        [
            FastingNotification(
                title: "Welcome to FastingTracker!",
                message: "Set up your profile and start your first fast. We're here to support your journey.",
                emoji: "👋",
                timestamp: Date(),
                type: .tip
            ),
            FastingNotification(
                title: "Tip: Stay Hydrated",
                message: "Remember to drink plenty of water during your fast. Herbal tea and black coffee are also fine.",
                emoji: "💧",
                timestamp: Date().addingTimeInterval(-3600),
                type: .tip
            )
        ]
    }
}

// MARK: - Notification Row

struct NotificationRow: View {
    let notification: FastingNotification

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(notification.emoji)
                .font(.title2)
                .frame(width: 44, height: 44)
                .background(Circle().fill(Color.gray.opacity(0.15)))

            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(notification.message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)

                Text(notification.timestamp, style: .relative)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}
