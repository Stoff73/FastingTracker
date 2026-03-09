import Foundation
import SwiftUI

struct CoreLearnArticle: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let emoji: String
    let category: Category
    let content: String
    let readTime: Int
    let keyPoints: [String]
    let tips: [String]

    var subtitle: String {
        let first = content.trimmingCharacters(in: .whitespacesAndNewlines)
        let sentence = first.components(separatedBy: ".").first ?? first
        let trimmed = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count > 80 ? String(trimmed.prefix(80)) + "…" : trimmed
    }

    enum Category: String, CaseIterable {
        case basics = "Basics"
        case benefits = "Benefits"
        case types = "Types"
        case tips = "Tips"
        case science = "Science"
        
        var emoji: String {
            switch self {
            case .basics: return "📚"
            case .benefits: return "💪"
            case .types: return "⏰"
            case .tips: return "💡"
            case .science: return "🧬"
            }
        }
    }
    
    static let articles: [CoreLearnArticle] = [
        CoreLearnArticle(
            title: "What is Intermittent Fasting?",
            emoji: "🕐",
            category: .basics,
            content: """
            Intermittent fasting (IF) is an eating pattern that cycles between periods of eating and fasting. It doesn't specify which foods you should eat but rather when you should eat them.
            
            Common intermittent fasting methods involve daily 16-hour fasts or fasting for 24 hours, twice per week. Humans have actually been fasting throughout evolution.
            """,
            readTime: 5,
            keyPoints: [
                "IF is an eating pattern, not a diet",
                "Focuses on when to eat, not what to eat",
                "Has been practiced throughout human history",
                "Triggers beneficial cellular changes"
            ],
            tips: [
                "Start with shorter fasting windows",
                "Stay hydrated during fasting periods",
                "Listen to your body's signals"
            ]
        ),
        
        CoreLearnArticle(
            title: "Health Benefits of Fasting",
            emoji: "❤️",
            category: .benefits,
            content: """
            Intermittent fasting can have powerful benefits for your body and brain. Here are evidence-based health benefits of intermittent fasting:
            
            Weight Loss: IF helps you lose weight and belly fat without consciously restricting calories.
            
            Insulin Resistance: IF can reduce insulin resistance, lowering blood sugar and potentially reducing the risk of type 2 diabetes.
            """,
            readTime: 7,
            keyPoints: [
                "Supports healthy weight loss",
                "Improves insulin sensitivity",
                "Reduces heart disease risk factors",
                "Enhances brain function and protection"
            ],
            tips: [
                "Combine with regular exercise",
                "Maintain a balanced diet during eating windows",
                "Be consistent with your fasting schedule"
            ]
        )
    ]
}

// Typealias for existing code compatibility
typealias LearnArticle = CoreLearnArticle