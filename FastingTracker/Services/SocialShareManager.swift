import SwiftUI

struct SocialShareManager {

    enum ShareMoment {
        case started(targetHours: Double)
        case inProgress(elapsedHours: Double, stage: FastingStage)
        case completed(elapsedHours: Double, targetHours: Double)
    }

    static func shareText(for moment: ShareMoment) -> String {
        switch moment {
        case .started(let targetHours):
            return "🚀 Just started a \(Int(targetHours))-hour fast! Let's go! #FastingTracker #IntermittentFasting"

        case .inProgress(let elapsedHours, let stage):
            let hours = Int(elapsedHours)
            return "\(stage.emoji) \(hours) hours into my fast \u{2014} currently in the \(stage.name) stage. \(stage.description). #FastingTracker #Fasting"

        case .completed(let elapsedHours, let targetHours):
            let hours = Int(elapsedHours)
            let target = Int(targetHours)
            let exceeded = hours >= target
            let emoji = exceeded ? "🏆" : "💪"
            return "\(emoji) Completed a \(hours)-hour fast (goal: \(target)h)! Feeling accomplished. #FastingTracker #IntermittentFasting #HealthGoals"
        }
    }
}
