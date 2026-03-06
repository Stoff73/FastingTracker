import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let currentStage: FastingStage
    let elapsedHours: Double
    let targetHours: Double
    let isActive: Bool
    let mood: String

    private let ringSize: CGFloat = 280
    private let lineWidth: CGFloat = 12

    var body: some View {
        ZStack {
            // Background ring — #e5e7eb
            Circle()
                .stroke(Color(red: 0.898, green: 0.906, blue: 0.922), lineWidth: lineWidth)

            // Progress arc
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    currentStage.color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.5), value: progress)

            // Stage markers on the ring
            if isActive {
                ForEach(FastingStage.stages) { stage in
                    if elapsedHours >= stage.hours {
                        stageMarker(stage: stage)
                    }
                }
            }

            // Center content
            VStack(spacing: 8) {
                Text(mood)
                    .font(.system(size: 64))

                if isActive {
                    VStack(spacing: 4) {
                        Text(currentStage.name)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color(red: 0.02, green: 0.588, blue: 0.404)) // #059669
                        Text(currentStage.description)
                            .font(.system(size: 12))
                            .foregroundStyle(Color(red: 0.42, green: 0.44, blue: 0.50)) // #6b7280
                    }
                } else {
                    VStack(spacing: 0) {
                        Text("What's Your")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Color(red: 0.055, green: 0.647, blue: 0.914)) // #0ea5e9
                        Text("Mood?")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Color(red: 0.055, green: 0.647, blue: 0.914))
                    }
                }
            }
        }
        .frame(width: ringSize, height: ringSize)
    }

    @ViewBuilder
    private func stageMarker(stage: FastingStage) -> some View {
        let angle = (stage.hours / targetHours) * 360 - 90
        let radius = ringSize / 2

        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 32, height: 32)
                .shadow(color: .black.opacity(0.08), radius: 2)

            Circle()
                .stroke(stage.color, lineWidth: 3)
                .frame(width: 32, height: 32)

            Text(stage.emoji)
                .font(.system(size: 16))
        }
        .offset(
            x: radius * cos(angle * .pi / 180),
            y: radius * sin(angle * .pi / 180)
        )
    }
}
