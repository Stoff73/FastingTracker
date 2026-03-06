import SwiftUI

struct FastingStage: Identifiable {
    let id = UUID()
    let name: String
    let hours: Double
    let color: Color
    let description: String
    let emoji: String
    let detailedInfo: String

    static let stages: [FastingStage] = [
        FastingStage(
            name: "Digestion",
            hours: 0,
            color: Color(red: 0.376, green: 0.647, blue: 0.98),
            description: "Body processing last meal",
            emoji: "💧",
            detailedInfo: "Your body is actively digesting food and absorbing nutrients. Blood sugar and insulin levels are elevated as your body processes glucose from your last meal. This phase typically lasts 3-5 hours depending on meal size."
        ),
        FastingStage(
            name: "Fat Burning",
            hours: 12,
            color: Color(red: 0.976, green: 0.451, blue: 0.086),
            description: "Switching to fat for energy",
            emoji: "🔥",
            detailedInfo: "With glycogen stores depleting, your body begins transitioning to fat as its primary fuel source. Insulin levels drop significantly, allowing stored fat to be accessed and broken down for energy. You may notice increased mental clarity."
        ),
        FastingStage(
            name: "Ketosis",
            hours: 18,
            color: Color(red: 0.937, green: 0.267, blue: 0.267),
            description: "Producing ketones",
            emoji: "⚡",
            detailedInfo: "Your liver is now producing ketone bodies from fatty acids. Ketones are an efficient fuel for your brain and muscles. Many people experience enhanced focus and reduced hunger during this stage as your body adapts to burning fat."
        ),
        FastingStage(
            name: "Autophagy",
            hours: 24,
            color: Color(red: 0.063, green: 0.725, blue: 0.506),
            description: "Cellular repair begins",
            emoji: "♻️",
            detailedInfo: "Autophagy is your body's cellular recycling program. Damaged proteins and organelles are broken down and recycled into new cellular components. This process is linked to longevity, reduced inflammation, and protection against neurodegenerative diseases."
        ),
        FastingStage(
            name: "Deep Cleanse",
            hours: 48,
            color: Color(red: 0.545, green: 0.361, blue: 0.965),
            description: "Enhanced mental clarity",
            emoji: "🧠",
            detailedInfo: "Growth hormone levels may increase significantly, supporting muscle preservation and fat metabolism. Immune system regeneration begins as old immune cells are recycled and new ones are produced. Deep cellular repair is underway."
        )
    ]

    static func currentStage(forElapsedHours hours: Double) -> FastingStage {
        var result = stages[0]
        for stage in stages {
            if hours >= stage.hours {
                result = stage
            }
        }
        return result
    }

    static func nextStage(forElapsedHours hours: Double) -> FastingStage? {
        for stage in stages {
            if hours < stage.hours {
                return stage
            }
        }
        return nil
    }
}
