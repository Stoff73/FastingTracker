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
        let schema = Schema([
            FastingSession.self,
            UserProfile.self,
            Friend.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        NotificationManager.shared.requestAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
