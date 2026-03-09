//
//  FastingTrackerApp.swift
//  FastingTracker
//
//  Created by ChrisSlater-Jones on 06/03/2026.
//

import SwiftUI
import SwiftData

@main
struct FastingTrackerApp: App {
    @State private var isOnboardingComplete = false
    
    var sharedModelContainer: ModelContainer = {
        do {
            return try ModelContainer(for: FastingSession.self, UserProfile.self, Friend.self)
        } catch {
            print("❌ ModelContainer error: \(error)")
            // Fall back to in-memory store so the app can still launch
            return try! ModelContainer(
                for: FastingSession.self, UserProfile.self, Friend.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
        }
    }()

    var body: some Scene {
        WindowGroup {
            Group {
                if isOnboardingComplete {
                    MainTabView()
                } else {
                    OnboardingView(isOnboardingComplete: $isOnboardingComplete)
                }
            }
            .onAppear {
                checkOnboardingStatus()
                NotificationManager.shared.requestAuthorization()
                NotificationManager.shared.setupNotificationCategories()
            }
        }
        .modelContainer(sharedModelContainer)
    }
    
    private func checkOnboardingStatus() {
        // Check if user profile exists to determine if onboarding is complete
        let context = sharedModelContainer.mainContext
        let descriptor = FetchDescriptor<UserProfile>()
        
        do {
            let profiles = try context.fetch(descriptor)
            isOnboardingComplete = !profiles.isEmpty
        } catch {
            print("❌ Failed to check onboarding status: \(error)")
            isOnboardingComplete = false
        }
    }
}
