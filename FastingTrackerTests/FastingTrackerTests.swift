//
//  FastingTrackerTests.swift
//  FastingTrackerTests
//
//  Created by ChrisSlater-Jones on 06/03/2026.
//

import Testing
import Foundation
import SwiftData
@testable import FastingTracker

@Suite("FastingTracker Core Tests")
struct FastingTrackerTests {

    // MARK: - FastingSession Tests
    
    @Test("FastingSession initialization")
    func testFastingSessionInit() async throws {
        let session = FastingSession(targetHours: 16, mood: "😊")
        
        #expect(session.targetHours == 16)
        #expect(session.mood == "😊")
        #expect(session.isActive == true)
        #expect(session.endDate == nil)
        #expect(session.moodLog.count == 1)
        #expect(session.moodLog.first?.emoji == "😊")
        #expect(session.notes.isEmpty)
    }
    
    @Test("FastingSession elapsed time calculation")
    func testFastingSessionElapsedTime() async throws {
        let now = Date()
        let twoHoursAgo = now.addingTimeInterval(-2 * 3600)
        
        let session = FastingSession(startDate: twoHoursAgo, targetHours: 16, mood: "😊")
        
        // Allow some tolerance for test execution time
        let elapsedHours = session.elapsedHours
        #expect(elapsedHours >= 1.9 && elapsedHours <= 2.1, "Elapsed time should be approximately 2 hours")
    }
    
    @Test("FastingSession progress calculation")
    func testFastingSessionProgress() async throws {
        let session = FastingSession(targetHours: 16, mood: "😊")
        
        // Mock 8 hours elapsed (half of 16-hour target)
        let eightHoursAgo = Date().addingTimeInterval(-8 * 3600)
        session.startDate = eightHoursAgo
        
        let progress = session.progress
        #expect(progress >= 0.4 && progress <= 0.6, "Progress should be approximately 0.5 for half completion")
    }
    
    @Test("FastingSession ending fast")
    func testEndFast() async throws {
        let session = FastingSession(targetHours: 16, mood: "😊")
        
        #expect(session.isActive == true)
        #expect(session.endDate == nil)
        
        session.endFast()
        
        #expect(session.isActive == false)
        #expect(session.endDate != nil)
    }
    
    @Test("FastingSession mood logging")
    func testMoodLogging() async throws {
        let session = FastingSession(targetHours: 16, mood: "😊")
        
        #expect(session.moodLog.count == 1)
        
        session.addMoodEntry("😓")
        
        #expect(session.moodLog.count == 2)
        #expect(session.moodLog.last?.emoji == "😓")
    }
    
    @Test("FastingSession success determination")
    func testFastingSuccess() async throws {
        let session = FastingSession(targetHours: 10, mood: "😊")
        
        // Complete the fast after 8 hours (80% of 10 hours)
        let eightHoursAgo = Date().addingTimeInterval(-8 * 3600)
        session.startDate = eightHoursAgo
        session.endFast()
        
        #expect(session.wasSuccessful == true, "Fast should be successful at 80% completion")
        
        // Test unsuccessful fast
        let shortSession = FastingSession(targetHours: 10, mood: "😊")
        let twoHoursAgo = Date().addingTimeInterval(-2 * 3600)
        shortSession.startDate = twoHoursAgo
        shortSession.endFast()
        
        #expect(shortSession.wasSuccessful == false, "Short fast should not be successful")
    }
    
    // MARK: - CoreFastingStage Tests
    
    @Test("CoreFastingStage current stage calculation")
    func testCurrentStage() async throws {
        let stage12 = CoreFastingStage.currentStage(forElapsedHours: 13)
        #expect(stage12.hours == 12, "Should be in Metabolic Switch stage at 13 hours")
        
        let stage16 = CoreFastingStage.currentStage(forElapsedHours: 17)
        #expect(stage16.hours == 16, "Should be in Fat Burning stage at 17 hours")
        
        let initialStage = CoreFastingStage.currentStage(forElapsedHours: 2)
        #expect(initialStage.name == "Getting Started", "Should be in Getting Started stage at 2 hours")
    }
    
    @Test("CoreFastingStage next stage calculation")
    func testNextStage() async throws {
        let nextStage = CoreFastingStage.nextStage(forElapsedHours: 10)
        #expect(nextStage?.hours == 12, "Next stage after 10 hours should be 12 hours")
        
        let noNextStage = CoreFastingStage.nextStage(forElapsedHours: 50)
        #expect(noNextStage == nil, "No next stage after maximum hours")
    }
    
    @Test("CoreFastingStage progress calculation")
    func testStageProgress() async throws {
        let progress = CoreFastingStage.stageProgress(forElapsedHours: 14)
        #expect(progress >= 0.0 && progress <= 1.0, "Stage progress should be between 0 and 1")
    }
    
    // MARK: - UserProfile Tests
    
    @Test("UserProfile initialization")
    func testUserProfileInit() async throws {
        let profile = UserProfile(
            displayName: "Test User",
            avatarEmoji: "👨‍💻",
            fastingGoalHours: 18,
            weeklyGoalDays: 6
        )
        
        #expect(profile.displayName == "Test User")
        #expect(profile.avatarEmoji == "👨‍💻")
        #expect(profile.fastingGoalHours == 18)
        #expect(profile.weeklyGoalDays == 6)
        #expect(profile.totalFastsCompleted == 0)
        #expect(profile.currentStreak == 0)
        #expect(profile.bestStreak == 0)
    }
    
    // MARK: - Friend Tests
    
    @Test("Friend initialization and progress")
    func testFriendInit() async throws {
        let friend = Friend(name: "Test Friend", avatarEmoji: "👩", phoneNumber: "1234567890")
        
        #expect(friend.name == "Test Friend")
        #expect(friend.avatarEmoji == "👩")
        #expect(friend.phoneNumber == "1234567890")
        #expect(friend.isFasting == false)
        #expect(friend.progress == 0.0)
        #expect(friend.elapsedHours == 0.0)
    }
    
    @Test("Friend fasting progress calculation")
    func testFriendFastingProgress() async throws {
        let friend = Friend(name: "Fasting Friend")
        friend.isFasting = true
        friend.fastingStartDate = Date().addingTimeInterval(-8 * 3600) // 8 hours ago
        friend.fastingTargetHours = 16
        
        #expect(friend.isFasting == true)
        #expect(friend.elapsedHours >= 7.9 && friend.elapsedHours <= 8.1)
        #expect(friend.progress >= 0.45 && friend.progress <= 0.55)
    }
    
    // MARK: - MoodEntry Tests
    
    @Test("MoodEntry initialization and formatting")
    func testMoodEntry() async throws {
        let mood = MoodEntry(emoji: "😊")
        
        #expect(mood.emoji == "😊")
        #expect(mood.timestamp != nil)
        #expect(!mood.formattedTime.isEmpty)
        #expect(!mood.formattedDate.isEmpty)
    }
    
    // MARK: - CoreShareManager Tests
    
    @Test("CoreShareManager text generation")
    func testShareTextGeneration() async throws {
        let stage = CoreFastingStage.stages.first { $0.hours == 16 }!
        
        let inProgressText = CoreShareManager.shareText(for: .inProgress(elapsedHours: 14.5, stage: stage))
        #expect(inProgressText.contains("14h 30m"))
        #expect(inProgressText.contains(stage.emoji))
        
        let completedText = CoreShareManager.shareText(for: .completed(totalHours: 18, targetHours: 16, stage: stage))
        #expect(completedText.contains("18h 0m"))
        #expect(completedText.contains("Completed"))
        
        let milestoneText = CoreShareManager.shareText(for: .milestone(stage: stage))
        #expect(milestoneText.contains("Milestone"))
        #expect(milestoneText.contains(stage.name))
    }
    
    // MARK: - Error Handler Tests
    
    @Test("ErrorHandler error handling")
    func testErrorHandler() async throws {
        let errorHandler = ErrorHandler()
        let testError = FastingTrackerError.validationError("Test validation error")
        
        errorHandler.handle(testError)
        
        #expect(errorHandler.errorHistory.count == 1)
        #expect(errorHandler.errorHistory.first?.localizedDescription == testError.localizedDescription)
    }
    
    @Test("ErrorHandler recovery actions")
    func testErrorRecoveryActions() async throws {
        let errorHandler = ErrorHandler()
        let authError = FastingTrackerError.authenticationError("Auth failed")
        
        let actions = errorHandler.recoveryActions(for: authError)
        
        #expect(actions.count >= 2)
        #expect(actions.contains { $0.title == "Try Again" })
        #expect(actions.contains { $0.title == "Cancel" })
    }
    
    // MARK: - AccessibilityHelper Tests
    
    @Test("AccessibilityHelper time description")
    func testAccessibleTimeDescription() async throws {
        let twoHoursThirtyMinutes = AccessibilityHelper.accessibleTimeDescription(hours: 2.5)
        #expect(twoHoursThirtyMinutes.contains("2 hours"))
        #expect(twoHoursThirtyMinutes.contains("30 minutes"))
        
        let oneHour = AccessibilityHelper.accessibleTimeDescription(hours: 1.0)
        #expect(oneHour == "1 hour")
        
        let thirtyMinutes = AccessibilityHelper.accessibleTimeDescription(hours: 0.5)
        #expect(thirtyMinutes.contains("30 minutes"))
        
        let zeroTime = AccessibilityHelper.accessibleTimeDescription(hours: 0.0)
        #expect(zeroTime == "less than a minute")
    }
    
    @Test("AccessibilityHelper progress description")
    func testAccessibleProgressDescription() async throws {
        let halfwayDescription = AccessibilityHelper.accessibleProgressDescription(current: 8, target: 16)
        #expect(halfwayDescription.contains("50 percent"))
        #expect(halfwayDescription.contains("remaining"))
        
        let completedDescription = AccessibilityHelper.accessibleProgressDescription(current: 16, target: 16)
        #expect(completedDescription.contains("100 percent"))
        #expect(completedDescription.contains("goal achieved"))
    }
    
    // MARK: - Integration Tests
    
    @Test("Complete fasting workflow")
    func testCompleteFastingWorkflow() async throws {
        // Create a fasting session
        let session = FastingSession(targetHours: 16, mood: "😊")
        
        // Simulate progression through stages
        session.startDate = Date().addingTimeInterval(-14 * 3600) // 14 hours ago
        
        let currentStage = CoreFastingStage.currentStage(forElapsedHours: session.elapsedHours)
        #expect(currentStage.hours == 12, "Should be in 12-hour stage")
        
        let nextStage = CoreFastingStage.nextStage(forElapsedHours: session.elapsedHours)
        #expect(nextStage?.hours == 16, "Next stage should be 16 hours")
        
        // Add mood entries
        session.addMoodEntry("💪")
        session.addMoodEntry("🔥")
        
        #expect(session.moodLog.count == 3) // Initial + 2 added
        
        // Complete the fast
        session.endFast()
        
        #expect(session.isActive == false)
        #expect(session.wasSuccessful == true) // 14 hours is > 80% of 16 hours
    }
}
