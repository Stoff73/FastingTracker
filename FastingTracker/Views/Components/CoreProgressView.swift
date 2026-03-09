import SwiftUI

struct CoreProgressView: View {
    let progress: Double
    let currentStage: CoreFastingStage
    let elapsedHours: Double
    let targetHours: Double
    let isActive: Bool
    let mood: String
    
    private let circleSize: CGFloat = 200
    private let lineWidth: CGFloat = 8
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: lineWidth)
                .frame(width: circleSize, height: circleSize)
            
            // Progress circle
            Circle()
                .trim(from: 0.0, to: min(progress, 1.0))
                .stroke(
                    LinearGradient(
                        colors: [.cyan, .blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: circleSize, height: circleSize)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
            
            // Center content
            VStack(spacing: 8) {
                // Stage emoji
                Text(currentStage.emoji)
                    .font(.system(size: 32))
                
                // Current mood
                Text(mood)
                    .font(.system(size: 24))
                
                // Elapsed time
                VStack(spacing: 2) {
                    Text(formattedElapsedTime)
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                        .foregroundStyle(.primary)
                    
                    Text("of \(String(format: "%.0f", targetHours))h goal")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                // Stage name
                Text(currentStage.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .animation(.easeInOut, value: currentStage.name)
    }
    
    private var formattedElapsedTime: String {
        let hours = Int(elapsedHours)
        let minutes = Int((elapsedHours - Double(hours)) * 60)
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}