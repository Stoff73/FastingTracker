import SwiftUI
import SwiftData

struct FriendsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Friend.name) private var friends: [Friend]
    @State private var showAddFriend = false
    @State private var newFriendName = ""
    @State private var newFriendPhone = ""
    @State private var selectedAvatarEmoji = "🧑"
    @State private var allowViewStatus = true

    private let avatarOptions = ["🧑", "👩", "👨", "🧔", "👱", "🧑‍🦰", "👩‍🦱", "🧑‍🦳"]

    var body: some View {
        NavigationStack {
            Group {
                if friends.isEmpty {
                    emptyState
                } else {
                    friendsList
                }
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddFriend = true
                    } label: {
                        Image(systemName: "person.badge.plus")
                    }
                }
            }
            .sheet(isPresented: $showAddFriend) {
                addFriendSheet
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.2.fill")
                .font(.system(size: 60))
                .foregroundStyle(.cyan.opacity(0.6))

            Text("Fast Together")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Add friends to see each other's fasting progress and support one another on your journey.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button {
                showAddFriend = true
            } label: {
                Label("Add a Friend", systemImage: "person.badge.plus")
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(.cyan))
            }
            .padding(.top, 8)
        }
    }

    // MARK: - Friends List

    private var friendsList: some View {
        List {
            let fasting = friends.filter(\.isFasting)
            let notFasting = friends.filter { !$0.isFasting }

            if !fasting.isEmpty {
                Section("Currently Fasting") {
                    ForEach(fasting) { friend in
                        FriendRow(friend: friend)
                    }
                    .onDelete { offsets in
                        deleteFriends(offsets, from: fasting)
                    }
                }
            }

            if !notFasting.isEmpty {
                Section("Not Fasting") {
                    ForEach(notFasting) { friend in
                        FriendRow(friend: friend)
                    }
                    .onDelete { offsets in
                        deleteFriends(offsets, from: notFasting)
                    }
                }
            }

            Section {
                Button {
                    showAddFriend = true
                } label: {
                    Label("Invite Friends", systemImage: "person.badge.plus")
                }
            }
        }
    }

    // MARK: - Add Friend Sheet

    private var addFriendSheet: some View {
        NavigationStack {
            Form {
                Section("Avatar") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(avatarOptions, id: \.self) { emoji in
                                Button {
                                    selectedAvatarEmoji = emoji
                                } label: {
                                    Text(emoji)
                                        .font(.system(size: 36))
                                        .padding(8)
                                        .background(
                                            Circle()
                                                .fill(selectedAvatarEmoji == emoji ? Color.cyan.opacity(0.2) : Color.clear)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Details") {
                    TextField("Name", text: $newFriendName)
                    TextField("Phone Number", text: $newFriendPhone)
                        .phoneKeyboard()
                }

                Section {
                    Toggle("Allow them to see my fasting status", isOn: $allowViewStatus)
                }
            }
            .navigationTitle("Add Friend")
            .inlineNavigationBar()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        resetForm()
                        showAddFriend = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addFriend()
                    }
                    .disabled(newFriendName.isEmpty)
                }
            }
        }
    }

    // MARK: - Actions

    private func addFriend() {
        let friend = Friend(
            name: newFriendName,
            avatarEmoji: selectedAvatarEmoji,
            phoneNumber: newFriendPhone,
            isAuthorizedToView: allowViewStatus
        )
        modelContext.insert(friend)
        try? modelContext.save()
        resetForm()
        showAddFriend = false
    }

    private func deleteFriends(_ offsets: IndexSet, from list: [Friend]) {
        for index in offsets {
            modelContext.delete(list[index])
        }
        try? modelContext.save()
    }

    private func resetForm() {
        newFriendName = ""
        newFriendPhone = ""
        selectedAvatarEmoji = "🧑"
        allowViewStatus = true
    }
}

// MARK: - Friend Row

struct FriendRow: View {
    let friend: Friend

    var body: some View {
        HStack(spacing: 12) {
            Text(friend.avatarEmoji)
                .font(.system(size: 36))
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color.gray.opacity(0.15)))

            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name)
                    .font(.headline)

                if friend.isFasting, friend.isAuthorizedToView {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.green)
                            .frame(width: 8, height: 8)
                        Text("Fasting \u{2014} \(friend.formattedElapsed)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } else if friend.isFasting {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.green)
                            .frame(width: 8, height: 8)
                        Text("Currently fasting")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Text("Not fasting")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if friend.isFasting, friend.isAuthorizedToView {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 3)
                        .frame(width: 40, height: 40)
                    Circle()
                        .trim(from: 0, to: friend.progress)
                        .stroke(Color.cyan, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 40, height: 40)
                        .rotationEffect(.degrees(-90))
                    Text("\(Int(friend.progress * 100))%")
                        .font(.system(size: 10, weight: .medium))
                }
            }
        }
        .padding(.vertical, 4)
    }
}
