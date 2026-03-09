import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isOnboardingComplete: Bool
    
    @State private var currentStep = 0
    @State private var displayName = ""
    @State private var selectedEmoji = "🧑"
    @State private var fastingGoalHours: Double = 16
    @State private var weeklyGoalDays: Int = 5
    @State private var notificationsEnabled = true
    @State private var shareWithFriends = true
    
    private let steps = [
        OnboardingStep.welcome,
        OnboardingStep.profile,
        OnboardingStep.goals,
        OnboardingStep.notifications,
        OnboardingStep.complete
    ]
    
    private let avatarOptions = ["🧑", "👩", "👨", "🧔", "👱", "🧑‍🦰", "👩‍🦱", "🧑‍🦳", "🦸", "🧑‍💻"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Bar
            ProgressView(value: Double(currentStep + 1), total: Double(steps.count))
                .tint(.cyan)
                .padding()
            
            TabView(selection: $currentStep) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    stepView(for: step)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentStep)
            
            // Navigation Buttons
            HStack {
                if currentStep > 0 {
                    Button("Back") {
                        withAnimation {
                            currentStep -= 1
                        }
                    }
                    .foregroundColor(.cyan)
                }
                
                Spacer()
                
                Button(currentStep == steps.count - 1 ? "Get Started" : "Next") {
                    if currentStep == steps.count - 1 {
                        completeOnboarding()
                    } else {
                        withAnimation {
                            currentStep += 1
                        }
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .background(canProceed ? Color.cyan : Color.gray)
                .cornerRadius(25)
                .disabled(!canProceed)
            }
            .padding()
        }
        .onAppear {
            NotificationManager.shared.setupNotificationCategories()
        }
    }
    
    @ViewBuilder
    private func stepView(for step: OnboardingStep) -> some View {
        VStack(spacing: 24) {
            Spacer()
            
            switch step {
            case .welcome:
                welcomeStep
            case .profile:
                profileStep
            case .goals:
                goalsStep
            case .notifications:
                notificationsStep
            case .complete:
                completeStep
            }
            
            Spacer()
        }
        .padding()
    }
    
    private var welcomeStep: some View {
        VStack(spacing: 24) {
            Text("⏰")
                .font(.system(size: 80))
            
            Text("Welcome to Fasting Tracker")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Your personal companion for intermittent fasting. Track your progress, connect with friends, and achieve your health goals.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    private var profileStep: some View {
        VStack(spacing: 24) {
            Text("👋")
                .font(.system(size: 60))
            
            Text("Let's create your profile")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Choose your avatar")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(avatarOptions, id: \.self) { emoji in
                                Button {
                                    selectedEmoji = emoji
                                } label: {
                                    Text(emoji)
                                        .font(.system(size: 30))
                                        .frame(width: 50, height: 50)
                                        .background(
                                            Circle()
                                                .fill(selectedEmoji == emoji ? Color.cyan.opacity(0.2) : Color.gray.opacity(0.1))
                                        )
                                        .overlay(
                                            Circle()
                                                .stroke(selectedEmoji == emoji ? Color.cyan : Color.clear, lineWidth: 2)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Display name")
                        .font(.headline)
                    
                    TextField("Enter your name", text: $displayName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        }
    }
    
    private var goalsStep: some View {
        VStack(spacing: 24) {
            Text("🎯")
                .font(.system(size: 60))
            
            Text("Set your fasting goals")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Daily fasting goal")
                        .font(.headline)
                    
                    HStack {
                        Text("\(Int(fastingGoalHours)) hours")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    
                    Slider(value: $fastingGoalHours, in: 12...24, step: 1)
                        .tint(.cyan)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Weekly goal")
                        .font(.headline)
                    
                    HStack {
                        Text("\(weeklyGoalDays) days per week")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    
                    Slider(value: Binding(
                        get: { Double(weeklyGoalDays) },
                        set: { weeklyGoalDays = Int($0) }
                    ), in: 1...7, step: 1)
                        .tint(.cyan)
                }
            }
        }
    }
    
    private var notificationsStep: some View {
        VStack(spacing: 24) {
            Text("🔔")
                .font(.system(size: 60))
            
            Text("Stay motivated with notifications")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 16) {
                Toggle("Enable notifications", isOn: $notificationsEnabled)
                    .font(.headline)
                
                if notificationsEnabled {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("We'll send you:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text("• Milestone achievements")
                            Spacer()
                        }
                        
                        HStack {
                            Text("• Motivational reminders")
                            Spacer()
                        }
                        
                        HStack {
                            Text("• Goal completion alerts")
                            Spacer()
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Toggle("Share with friends", isOn: $shareWithFriends)
                    .font(.headline)
            }
        }
    }
    
    private var completeStep: some View {
        VStack(spacing: 24) {
            Text("🎉")
                .font(.system(size: 80))
            
            Text("You're all set!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Ready to start your fasting journey? Your profile has been created and you're ready to begin tracking your progress.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    private var canProceed: Bool {
        switch steps[currentStep] {
        case .welcome:
            return true
        case .profile:
            return !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .goals, .notifications, .complete:
            return true
        }
    }
    
    private func completeOnboarding() {
        // Create user profile
        let profile = UserProfile(
            displayName: displayName.trimmingCharacters(in: .whitespacesAndNewlines),
            avatarEmoji: selectedEmoji,
            fastingGoalHours: fastingGoalHours,
            weeklyGoalDays: weeklyGoalDays
        )
        profile.notificationsEnabled = notificationsEnabled
        profile.shareWithFriends = shareWithFriends
        
        modelContext.insert(profile)
        
        do {
            try modelContext.save()
            
            // Request notification permission if enabled
            if notificationsEnabled {
                NotificationManager.shared.requestAuthorization()
            }
            
            // Complete onboarding
            isOnboardingComplete = true
            
        } catch {
            print("❌ Failed to save profile during onboarding: \(error.localizedDescription)")
        }
    }
}

enum OnboardingStep: CaseIterable {
    case welcome
    case profile
    case goals
    case notifications
    case complete
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
        .modelContainer(for: [UserProfile.self], inMemory: true)
}