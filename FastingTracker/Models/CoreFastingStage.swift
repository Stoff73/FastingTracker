import Foundation
import SwiftUI

struct CoreFastingStage: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let hours: Double
    let description: String
    let benefits: [String]

    var color: Color {
        switch hours {
        case 0..<4:   return Color(red: 0.60, green: 0.63, blue: 0.68) // gray — Fed State
        case 4..<8:   return Color(red: 0.98, green: 0.75, blue: 0.24) // yellow — Early Fasting
        case 8..<12:  return Color(red: 0.96, green: 0.49, blue: 0.22) // orange — Fat Burning
        case 12..<16: return Color(red: 0.02, green: 0.59, blue: 0.40) // green — Ketosis
        case 16..<20: return Color(red: 0.06, green: 0.65, blue: 0.91) // cyan — Deep Ketosis
        case 20..<24: return Color(red: 0.55, green: 0.27, blue: 0.91) // purple — Autophagy Peak
        default:      return Color(red: 0.24, green: 0.32, blue: 0.87) // indigo — Extended Benefits
        }
    }
    
    static let stages: [CoreFastingStage] = [
        CoreFastingStage(
            name: "Fed State",
            emoji: "🍽️",
            hours: 0,
            description: "Your body is processing the food you just ate",
            benefits: ["Insulin levels are elevated", "Body is storing energy"]
        ),
        CoreFastingStage(
            name: "Early Fasting",
            emoji: "🌅",
            hours: 4,
            description: "Your body begins to transition into fasting mode",
            benefits: ["Blood sugar stabilizing", "Initial fat burning begins"]
        ),
        CoreFastingStage(
            name: "Fat Burning",
            emoji: "🔥",
            hours: 8,
            description: "Your body is now primarily burning fat for energy",
            benefits: ["Increased fat oxidation", "Ketone production starts"]
        ),
        CoreFastingStage(
            name: "Ketosis",
            emoji: "⚡",
            hours: 12,
            description: "You're entering ketosis - your brain is using ketones",
            benefits: ["Mental clarity improves", "Steady energy levels"]
        ),
        CoreFastingStage(
            name: "Deep Ketosis",
            emoji: "🧠",
            hours: 16,
            description: "Deep ketosis with enhanced mental performance",
            benefits: ["Peak mental clarity", "Autophagy activation"]
        ),
        CoreFastingStage(
            name: "Autophagy Peak",
            emoji: "🔄",
            hours: 20,
            description: "Cellular repair and regeneration at its peak",
            benefits: ["Enhanced autophagy", "Cellular cleanup", "Anti-aging benefits"]
        ),
        CoreFastingStage(
            name: "Extended Benefits",
            emoji: "✨",
            hours: 24,
            description: "Extended fasting benefits continue to compound",
            benefits: ["Growth hormone increase", "Immune system reset", "Deep cellular repair"]
        )
    ]
    
    static func currentStage(forElapsedHours hours: Double) -> CoreFastingStage {
        let sortedStages = stages.sorted { $0.hours < $1.hours }
        
        for i in stride(from: sortedStages.count - 1, through: 0, by: -1) {
            if hours >= sortedStages[i].hours {
                return sortedStages[i]
            }
        }
        
        return stages.first ?? CoreFastingStage(
            name: "Starting",
            emoji: "🌱",
            hours: 0,
            description: "Beginning your fasting journey",
            benefits: ["Preparing for fasting benefits"]
        )
    }
    
    static func nextStage(forElapsedHours hours: Double) -> CoreFastingStage? {
        let sortedStages = stages.sorted { $0.hours < $1.hours }
        
        for stage in sortedStages {
            if stage.hours > hours {
                return stage
            }
        }
        
        return nil
    }
}

// Typealias for all existing code
typealias FastingStage = CoreFastingStage