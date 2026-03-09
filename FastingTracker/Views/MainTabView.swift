import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var fastingManager = FastingManager()
    @State private var authManager = AuthenticationManager()

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(fastingManager: fastingManager)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            FriendsView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Friends")
                }
                .tag(1)

            CoreNotificationsView()
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Notifications")
                }
                .tag(2)

            LearnView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Learn")
                }
                .tag(3)

            ProfileView(authManager: authManager, fastingManager: fastingManager)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(4)
        }
        .tint(.cyan)
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [FastingSession.self, UserProfile.self, Friend.self], inMemory: true)
}
