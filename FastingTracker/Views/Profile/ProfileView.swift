import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @Bindable var authManager: AuthenticationManager
    @Bindable var fastingManager: FastingManager

    @State private var isEditing = false
    @State private var editName = ""
    @State private var editEmoji = "🧑"
    @State private var editGoalHours: Double = 16
    @State private var editWeeklyDays: Int = 5
    @State private var showHistory = false

    private var profile: UserProfile? { profiles.first }

    private let avatarOptions = ["🧑", "👩", "👨", "🧔", "👱", "🧑‍🦰", "👩‍🦱", "🧑‍🦳", "🦸", "🧑‍💻"]

    var body: some View {
        NavigationStack {
            Group {
                if authManager.isAuthenticated {
                    profileContent
                } else {
                    lockScreen
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                if authManager.isAuthenticated {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            authManager.lock()
                        } label: {
                            Image(systemName: "lock.fill")
                        }
                    }
                }
            }
        }
        .onAppear {
            ensureProfile()
        }
    }

    // MARK: - Lock Screen

    private var lockScreen: some View {
        VStack(spacing: 24) {
            Image(systemName: "faceid")
                .font(.system(size: 60))
                .foregroundStyle(.cyan)

            Text("Profile Locked")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Authenticate with \(authManager.biometricType) to view your profile and fasting history.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button {
                Task {
                    await authManager.authenticate()
                }
            } label: {
                Label("Unlock with \(authManager.biometricType)", systemImage: "faceid")
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(Capsule().fill(.cyan))
            }

            if let error = authManager.authError {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
    }

    // MARK: - Profile Content

    private var profileContent: some View {
        List {
            // Profile Header
            Section {
                HStack(spacing: 16) {
                    Text(profile?.avatarEmoji ?? "🧑")
                        .font(.system(size: 50))
                        .frame(width: 70, height: 70)
                        .background(Circle().fill(Color.gray.opacity(0.15)))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(profile?.displayName.isEmpty == false ? profile!.displayName : "Fasting Enthusiast")
                            .font(.title3)
                            .fontWeight(.semibold)

                        if let created = profile?.createdAt {
                            Text("Member since \(created, format: .dateTime.month(.wide).year())")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.vertical, 8)
            }

            // Stats
            Section("Statistics") {
                StatRow(label: "Fasts Completed", value: "\(profile?.totalFastsCompleted ?? 0)")
                StatRow(label: "Longest Fast", value: formatHours(profile?.longestFastHours ?? 0))
                StatRow(label: "Current Streak", value: "\(profile?.currentStreak ?? 0) days")
                StatRow(label: "Best Streak", value: "\(profile?.bestStreak ?? 0) days")
            }

            // Fasting History
            Section("History") {
                Button {
                    showHistory = true
                } label: {
                    Label("View Fasting History", systemImage: "clock.arrow.circlepath")
                }
            }

            // Goals
            Section("Goals") {
                HStack {
                    Text("Daily Fasting Goal")
                    Spacer()
                    Text("\(Int(profile?.fastingGoalHours ?? 16))h")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Weekly Goal")
                    Spacer()
                    Text("\(profile?.weeklyGoalDays ?? 5) days/week")
                        .foregroundStyle(.secondary)
                }
            }

            // Settings
            Section("Settings") {
                Toggle("Notifications", isOn: Binding(
                    get: { profile?.notificationsEnabled ?? true },
                    set: { newValue in
                        profile?.notificationsEnabled = newValue
                        try? modelContext.save()
                        if newValue {
                            NotificationManager.shared.requestAuthorization()
                        }
                    }
                ))

                Toggle("Share Status with Friends", isOn: Binding(
                    get: { profile?.shareWithFriends ?? true },
                    set: { newValue in
                        profile?.shareWithFriends = newValue
                        try? modelContext.save()
                    }
                ))
            }

            // Edit Profile
            Section {
                Button {
                    if let profile {
                        editName = profile.displayName
                        editEmoji = profile.avatarEmoji
                        editGoalHours = profile.fastingGoalHours
                        editWeeklyDays = profile.weeklyGoalDays
                    }
                    isEditing = true
                } label: {
                    Label("Edit Profile", systemImage: "pencil")
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            editProfileSheet
        }
        .sheet(isPresented: $showHistory) {
            historySheet
        }
    }

    // MARK: - Edit Profile Sheet

    private var editProfileSheet: some View {
        NavigationStack {
            Form {
                Section("Avatar") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(avatarOptions, id: \.self) { emoji in
                                Button {
                                    editEmoji = emoji
                                } label: {
                                    Text(emoji)
                                        .font(.system(size: 36))
                                        .padding(8)
                                        .background(
                                            Circle()
                                                .fill(editEmoji == emoji ? Color.cyan.opacity(0.2) : Color.clear)
                                        )
                                }
                            }
                        }
                    }
                }

                Section("Name") {
                    TextField("Display Name", text: $editName)
                }

                Section("Goals") {
                    Stepper("Daily Goal: \(Int(editGoalHours))h", value: $editGoalHours, in: 1...72, step: 1)
                    Stepper("Weekly: \(editWeeklyDays) days", value: $editWeeklyDays, in: 1...7)
                }
            }
            .navigationTitle("Edit Profile")
            .inlineNavigationBar()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isEditing = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveProfile()
                        isEditing = false
                    }
                }
            }
        }
    }

    // MARK: - History Sheet

    private var historySheet: some View {
        NavigationStack {
            List {
                let sessions = fastingManager.completedSessions(modelContext: modelContext)
                if sessions.isEmpty {
                    ContentUnavailableView(
                        "No History Yet",
                        systemImage: "clock",
                        description: Text("Complete your first fast to see it here.")
                    )
                } else {
                    ForEach(sessions) { session in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(session.mood)
                                    .font(.title3)
                                Text(session.startDate, format: .dateTime.month().day().year())
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                                Text(session.durationDescription)
                                    .font(.subheadline)
                                    .foregroundStyle(.cyan)
                            }

                            HStack {
                                Text("Goal: \(Int(session.targetHours))h")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                let pct = Int(session.progress * 100)
                                Text("Achieved: \(pct)%")
                                    .font(.caption)
                                    .foregroundStyle(pct >= 80 ? .green : .orange)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Fasting History")
            .inlineNavigationBar()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { showHistory = false }
                }
            }
        }
    }

    // MARK: - Helpers

    private func ensureProfile() {
        if profiles.isEmpty {
            let profile = UserProfile()
            modelContext.insert(profile)
            try? modelContext.save()
        }
    }

    private func saveProfile() {
        guard let profile else { return }
        profile.displayName = editName
        profile.avatarEmoji = editEmoji
        profile.fastingGoalHours = editGoalHours
        profile.weeklyGoalDays = editWeeklyDays
        try? modelContext.save()
    }

    private func formatHours(_ hours: Double) -> String {
        if hours == 0 { return "—" }
        let h = Int(hours)
        let m = Int((hours - Double(h)) * 60)
        return "\(h)h \(m)m"
    }
}

struct StatRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .foregroundStyle(.cyan)
        }
    }
}
