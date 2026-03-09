import Foundation

enum CoreShareType {
    case started(targetHours: Double)
    case inProgress(elapsedHours: Double, stage: CoreFastingStage)
    case completed(totalHours: Double, targetHours: Double)
    case milestone(stage: CoreFastingStage, elapsedHours: Double)
}

struct CoreShareManager {
    
    static func shareText(for shareType: CoreShareType) -> String {
        switch shareType {
        case .started(let targetHours):
            let targetText = String(format: "%.0f", targetHours)
            return "🚀 Just started a \(targetText)-hour fast! Here we go! #FastingTracker #IntermittentFasting #NewFast"
            
        case .inProgress(let hours, let stage):
            let hoursText = String(format: "%.1f", hours)
            return "🕐 I'm currently \(hoursText) hours into my fast and in the \(stage.name) stage \(stage.emoji)! #FastingTracker #IntermittentFasting"
            
        case .completed(let totalHours, let targetHours):
            let totalText = String(format: "%.1f", totalHours)
            let targetText = String(format: "%.0f", targetHours)
            if totalHours >= targetHours {
                return "🎉 Just completed my \(targetText)-hour fast! Went \(totalText) hours total. Feeling amazing! #FastingTracker #FastingGoals"
            } else {
                return "✅ Ended my fast at \(totalText) hours. Every fast is progress! #FastingTracker #FastingJourney"
            }
            
        case .milestone(let stage, let hours):
            let hoursText = String(format: "%.1f", hours)
            return "\(stage.emoji) Milestone reached! I'm \(hoursText) hours into my fast and just entered the \(stage.name) stage! \(stage.description) #FastingTracker #\(stage.name.replacingOccurrences(of: " ", with: ""))"
        }
    }
    
    static func shareURL(for shareType: CoreShareType) -> String {
        return "https://apps.apple.com/app/fasting-tracker"
    }
    
    static func formatAchievement(_ achievement: String, value: Any) -> String {
        switch achievement {
        case "longest_fast":
            if let hours = value as? Double {
                return "🏆 New personal record! Just completed my longest fast: \(String(format: "%.1f", hours)) hours! #FastingTracker #PersonalRecord"
            }
        case "streak":
            if let days = value as? Int {
                return "🔥 I'm on a \(days)-day fasting streak! Consistency is key! #FastingTracker #FastingStreak"
            }
        case "first_fast":
            return "🌱 Just completed my first fast with FastingTracker! Starting my intermittent fasting journey! #FastingTracker #FirstFast"
        default:
            break
        }
        
        return "🎉 New achievement unlocked with FastingTracker! #FastingTracker #Achievement"
    }
}