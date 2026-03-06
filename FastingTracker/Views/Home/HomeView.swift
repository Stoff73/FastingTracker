import SwiftUI
import SwiftData

// Exact color constants from the HTML prototype
private let skyBlue = Color(red: 0.055, green: 0.647, blue: 0.914)     // #0ea5e9
private let darkText = Color(red: 0.122, green: 0.161, blue: 0.216)    // #1f2937
private let grayText = Color(red: 0.42, green: 0.44, blue: 0.50)       // #6b7280
private let borderGray = Color(red: 0.82, green: 0.84, blue: 0.86)     // #d1d5db
private let bgColor = Color(red: 0.976, green: 0.98, blue: 0.984)      // #f9fafb
private let dangerRed = Color(red: 0.937, green: 0.267, blue: 0.267)   // #ef4444
private let modalGray = Color(red: 0.898, green: 0.906, blue: 0.922)   // #e5e7eb

// Date format matching HTML: "Mon, Sep 23"
private let dateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "EEE, MMM d"
    return f
}()

// Time format matching HTML: "12:00 PM"
private let timeFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "h:mm a"
    return f
}()

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var fastingManager: FastingManager
    @State private var targetHours: Double = 16
    @State private var currentMood: String = "😊"
    @State private var showEditStart = false
    @State private var showEditTarget = false
    @State private var editedDate = Date()
    @State private var completedShareText: String?

    private var inProgressShareText: String {
        SocialShareManager.shareText(for: .inProgress(
            elapsedHours: fastingManager.elapsedHours,
            stage: fastingManager.currentStage
        ))
    }

    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header with share button
                    HStack {
                        Spacer()
                        if fastingManager.isActive {
                            ShareLink(item: inProgressShareText) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 18))
                                    .foregroundStyle(skyBlue)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)

                    // Circular Progress
                    CircularProgressView(
                        progress: fastingManager.progress,
                        currentStage: fastingManager.currentStage,
                        elapsedHours: fastingManager.elapsedHours,
                        targetHours: fastingManager.activeFast?.targetHours ?? targetHours,
                        isActive: fastingManager.isActive,
                        mood: currentMood
                    )
                    .padding(.bottom, 32)

                    // Timer Controls: − [54 hr] +
                    HStack(spacing: 16) {
                        Button {
                            adjustTarget(-1)
                        } label: {
                            Text("\u{2212}")
                                .font(.system(size: 20))
                                .foregroundStyle(darkText)
                                .frame(width: 48, height: 48)
                                .background(Color.white)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(borderGray, lineWidth: 2))
                        }
                        .buttonStyle(.plain)

                        Text("\(Int(fastingManager.activeFast?.targetHours ?? targetHours)) hr")
                            .font(.system(size: 32, weight: .light))
                            .foregroundStyle(darkText)

                        Button {
                            adjustTarget(1)
                        } label: {
                            Text("+")
                                .font(.system(size: 20))
                                .foregroundStyle(darkText)
                                .frame(width: 48, height: 48)
                                .background(Color.white)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(borderGray, lineWidth: 2))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.bottom, 24)

                    // Time Display: Start | Elapsed | Target
                    HStack(alignment: .bottom) {
                        VStack(spacing: 4) {
                            Text("Start")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(darkText)
                            Text(dateFormatter.string(from: startDate))
                                .font(.system(size: 14))
                                .foregroundStyle(grayText)
                            Text(timeFormatter.string(from: startDate))
                                .font(.system(size: 14))
                                .foregroundStyle(grayText)
                            Button("EDIT") {
                                editedDate = fastingManager.activeFast?.startDate ?? Date()
                                showEditStart = true
                            }
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(skyBlue)
                            .buttonStyle(.plain)
                        }
                        .frame(maxWidth: .infinity)

                        VStack(spacing: 4) {
                            Text("Elapsed")
                                .font(.system(size: 14))
                                .foregroundStyle(grayText)
                            Text(fastingManager.formattedElapsedTime)
                                .font(.system(size: 48, weight: .light))
                                .foregroundStyle(darkText)
                                .monospacedDigit()
                                .minimumScaleFactor(0.6)
                        }
                        .frame(maxWidth: .infinity)

                        VStack(spacing: 4) {
                            Text("Target")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(darkText)
                            Text(dateFormatter.string(from: targetEndDate))
                                .font(.system(size: 14))
                                .foregroundStyle(grayText)
                            Text(timeFormatter.string(from: targetEndDate))
                                .font(.system(size: 14))
                                .foregroundStyle(grayText)
                            Button("EDIT") {
                                editedDate = targetEndDate
                                showEditTarget = true
                            }
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(skyBlue)
                            .buttonStyle(.plain)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)

                    // Mood Selector
                    MoodSelectorView(selectedMood: $currentMood) { mood in
                        fastingManager.updateMood(mood)
                    }
                    .padding(.bottom, 24)

                    // Start / End Button
                    Button {
                        if fastingManager.isActive {
                            completedShareText = SocialShareManager.shareText(for: .completed(
                                elapsedHours: fastingManager.elapsedHours,
                                targetHours: fastingManager.activeFast?.targetHours ?? targetHours
                            ))
                            fastingManager.endFast()
                        } else {
                            fastingManager.startFast(targetHours: targetHours, mood: currentMood)
                            completedShareText = SocialShareManager.shareText(for: .started(targetHours: targetHours))
                        }
                    } label: {
                        Text(fastingManager.isActive ? "End Fast" : "Start Fast")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(fastingManager.isActive ? dangerRed : skyBlue)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 24)

                    // Share after start/end — appears briefly
                    if let text = completedShareText {
                        ShareLink(item: text) {
                            Text("Share to Social Media")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(skyBlue)
                                .padding(.top, 12)
                        }
                    }

                    // Community section
                    VStack(spacing: 8) {
                        Text("11,981")
                            .font(.system(size: 14))
                            .foregroundStyle(grayText)
                        Text("Fasting Now")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(darkText)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 40)
                }
            }

            // Edit Start Modal
            if showEditStart {
                editModal(
                    title: "Edit Start Time",
                    date: $editedDate,
                    onCancel: { showEditStart = false },
                    onSave: {
                        fastingManager.updateStartTime(editedDate)
                        showEditStart = false
                    }
                )
            }

            // Edit Target Modal
            if showEditTarget {
                editModal(
                    title: "Edit Target Time",
                    date: $editedDate,
                    onCancel: { showEditTarget = false },
                    onSave: {
                        if let fast = fastingManager.activeFast {
                            let newTarget = editedDate.timeIntervalSince(fast.startDate) / 3600
                            fastingManager.updateTargetHours(newTarget)
                            targetHours = max(1, newTarget)
                        }
                        showEditTarget = false
                    }
                )
            }
        }
        .onAppear {
            fastingManager.configure(modelContext: modelContext)
            if let fast = fastingManager.activeFast {
                targetHours = fast.targetHours
                currentMood = fast.mood
            }
        }
    }

    // MARK: - Edit Modal (matches HTML modal-content)

    @ViewBuilder
    private func editModal(
        title: String,
        date: Binding<Date>,
        onCancel: @escaping () -> Void,
        onSave: @escaping () -> Void
    ) -> some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture { onCancel() }

            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(darkText)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Date & Time")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color(red: 0.216, green: 0.255, blue: 0.318))
                    DatePicker("", selection: date)
                        .labelsHidden()
                        .datePickerStyle(.compact)
                }

                HStack(spacing: 12) {
                    Button {
                        onCancel()
                    } label: {
                        Text("Cancel")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(darkText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(modalGray)
                            )
                    }
                    .buttonStyle(.plain)

                    Button {
                        onSave()
                    } label: {
                        Text("Save")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(skyBlue)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 8)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
            )
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Helpers

    private func adjustTarget(_ delta: Double) {
        if fastingManager.isActive {
            let current = fastingManager.activeFast?.targetHours ?? targetHours
            let newTarget = max(1, current + delta)
            fastingManager.updateTargetHours(newTarget)
            targetHours = newTarget
        } else {
            targetHours = max(1, targetHours + delta)
        }
    }

    private var startDate: Date {
        fastingManager.activeFast?.startDate ?? Date()
    }

    private var targetEndDate: Date {
        let start = fastingManager.activeFast?.startDate ?? Date()
        let hours = fastingManager.activeFast?.targetHours ?? targetHours
        return start.addingTimeInterval(hours * 3600)
    }
}
