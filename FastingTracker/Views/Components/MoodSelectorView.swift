import SwiftUI

struct MoodSelectorView: View {
    @Binding var selectedMood: String
    let onSelect: (String) -> Void

    private let moods = ["😊", "😌", "💪", "🤗", "😴", "🔥"]
    // #dbeafe
    private let activeBackground = Color(red: 0.859, green: 0.914, blue: 0.996)

    var body: some View {
        HStack(spacing: 12) {
            ForEach(moods, id: \.self) { mood in
                Button {
                    selectedMood = mood
                    onSelect(mood)
                } label: {
                    Text(mood)
                        .font(.system(size: 32))
                        .padding(8)
                        .background(
                            Circle()
                                .fill(selectedMood == mood ? activeBackground : Color.clear)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }
}
