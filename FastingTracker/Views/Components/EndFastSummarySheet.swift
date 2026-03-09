import SwiftUI

struct EndFastSummarySheet: View {
    @Bindable var fastingManager: FastingManager

    /// Called with the completed share text after save.
    var onSave: (String) -> Void
    var onDiscard: () -> Void
    var onResume: () -> Void

    @State private var notes: String = ""

    private let skyBlue  = Color(red: 0.055, green: 0.647, blue: 0.914)
    private let dangerRed = Color(red: 0.937, green: 0.267, blue: 0.267)
    private let grayText  = Color(red: 0.42,  green: 0.44,  blue: 0.50)

    private var elapsedHours: Double { fastingManager.elapsedTime / 3600 }
    private var targetHours: Double  { fastingManager.activeFast?.targetHours ?? 16 }
    private var pct: Int { targetHours > 0 ? min(Int(elapsedHours / targetHours * 100), 100) : 0 }
    private var achieved: Bool { pct >= 80 }
    private var stage: CoreFastingStage { CoreFastingStage.currentStage(forElapsedHours: elapsedHours) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {

                    // Mood + summary headline
                    VStack(spacing: 8) {
                        Text(fastingManager.activeFast?.mood ?? "😊")
                            .font(.system(size: 64))

                        Text(achieved ? "🎉 Fast Complete!" : "Fast Ended")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(fastingManager.formattedElapsedTime)
                            .font(.system(size: 48, weight: .light))
                            .monospacedDigit()
                            .foregroundStyle(skyBlue)
                    }
                    .padding(.top, 8)

                    // Stats card
                    VStack(spacing: 0) {
                        statRow(
                            label: "Goal",
                            value: "\(Int(targetHours))h",
                            valueColor: .primary
                        )
                        Divider()
                        statRow(
                            label: "Achieved",
                            value: "\(pct)%",
                            valueColor: achieved ? .green : .orange
                        )
                        Divider()
                        statRow(
                            label: "Stage Reached",
                            value: "\(stage.emoji) \(stage.name)",
                            valueColor: stage.color
                        )
                    }
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                    .padding(.horizontal)

                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes (optional)")
                            .font(.subheadline)
                            .foregroundStyle(grayText)
                            .padding(.horizontal)

                        TextField("How did it go?", text: $notes, axis: .vertical)
                            .lineLimit(3...5)
                            .padding(12)
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
                            .padding(.horizontal)
                    }

                    // Action buttons
                    VStack(spacing: 12) {
                        Button {
                            let shareText = CoreShareManager.shareText(for: .completed(
                                totalHours: elapsedHours,
                                targetHours: targetHours
                            ))
                            fastingManager.confirmSaveFast(notes: notes)
                            onSave(shareText)
                        } label: {
                            Text("Save Fast")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(skyBlue)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)

                        Button {
                            fastingManager.resumeFast()
                            onResume()
                        } label: {
                            Text("Keep Going")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(skyBlue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(skyBlue.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)

                        Button(role: .destructive) {
                            fastingManager.discardFast()
                            onDiscard()
                        } label: {
                            Text("Discard Fast")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(dangerRed)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("End Fast")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    @ViewBuilder
    private func statRow(label: String, value: String, valueColor: Color) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundStyle(valueColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
