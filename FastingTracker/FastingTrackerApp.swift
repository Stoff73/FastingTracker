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
            MainTabView()
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
