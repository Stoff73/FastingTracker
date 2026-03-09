import SwiftUI
import SwiftData

struct FastingHistorySheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var fastingManager: FastingManager

    var body: some View {
        NavigationStack {
            Group {
                let sessions = fastingManager.completedSessions(modelContext: modelContext)
                if sessions.isEmpty {
                    ContentUnavailableView(
                        "No Saved Fasts",
                        systemImage: "clock",
                        description: Text("Complete and save a fast to see it here.")
                    )
                } else {
                    List {
                        ForEach(sessions) { session in
                            HistoryRow(session: session)
                        }
                        .onDelete { offsets in
                            deleteSessions(sessions: sessions, at: offsets)
                        }
                    }
                }
            }
            .navigationTitle("Fasting History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func deleteSessions(sessions: [FastingSession], at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(sessions[index])
        }
        try? modelContext.save()
    }
}

// MARK: - Row

private struct HistoryRow: View {
    let session: FastingSession

    private var pct: Int {
        session.targetHours > 0 ? min(Int(session.progress * 100), 100) : 0
    }
    private var achieved: Bool { pct >= 80 }

    private var shareText: String {
        CoreShareManager.shareText(for: .completed(
            totalHours: session.elapsedHours,
            targetHours: session.targetHours
        ))
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Mood circle
            Text(session.mood)
                .font(.system(size: 28))
                .frame(width: 44, height: 44)
                .background(Circle().fill(Color(.systemGray6)))

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(session.startDate, format: .dateTime.month(.wide).day().year())
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(session.durationDescription)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.cyan)
                }

                HStack(spacing: 12) {
                    Label("Goal: \(Int(session.targetHours))h", systemImage: "target")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("\(pct)% achieved")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(achieved ? .green : .orange)
                }

                if !session.notes.isEmpty {
                    Text(session.notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            ShareLink(item: shareText) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 15))
                    .foregroundStyle(.cyan)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
