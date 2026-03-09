# Fasting Tracker - Xcode Project Setup Guide

## Project Configuration

### Basic Settings
- **Product Name**: Fasting Tracker
- **Bundle Identifier**: com.yourcompany.fastingtracker (replace with your domain)
- **Version**: 1.0
- **Build**: 1
- **Deployment Target**: iOS 17.0+ (for SwiftData and latest SwiftUI features)

### Target Configuration

#### Fasting Tracker (Main App Target)
- **Platform**: iOS
- **Device Family**: iPhone, iPad
- **Orientation**: Portrait (Primary), Portrait Upside Down (iPad), Landscape Left (iPad), Landscape Right (iPad)
- **Status Bar Style**: Default
- **Requires Full Screen**: Yes (iPhone)

#### FastingTrackerTests (Test Target)
- **Host Application**: Fasting Tracker
- **Test Bundle**: com.yourcompany.fastingtracker.tests

#### FastingTrackerUITests (UI Test Target)
- **Target Application**: Fasting Tracker
- **UI Test Bundle**: com.yourcompany.fastingtracker.uitests

### Required Frameworks
All frameworks are part of iOS SDK (no external dependencies):

- **SwiftUI**: Core UI framework
- **SwiftData**: Data persistence
- **UserNotifications**: Push notifications and local notifications
- **LocalAuthentication**: Face ID/Touch ID authentication
- **Contacts**: Friend management (optional)
- **Foundation**: Core functionality
- **UIKit**: UIKit interop where needed

### Capabilities & Entitlements

Enable these capabilities in Xcode:
1. **Push Notifications**: For local notifications
2. **Background Modes**: Background processing (if needed for notifications)

### App Transport Security (ATS)
Since the app works offline, no special ATS configuration is needed. Keep default secure settings.

### Build Settings

#### Swift Settings
- **Swift Language Version**: Swift 5.9+
- **Swift Compilation Mode**: 
  - Debug: Incremental
  - Release: Whole Module Optimization

#### Code Signing
- **Development Team**: Your Apple Developer Team
- **Code Signing Identity**: 
  - Debug: iPhone Developer
  - Release: iPhone Distribution
- **Provisioning Profile**: 
  - Debug: Automatic (Xcode Managed)
  - Release: Manual (App Store distribution profile)

#### Build Configurations
```
Debug:
- Enable Testability: Yes
- Optimization Level: None [-O0]
- Active Compilation Conditions: DEBUG

Release:
- Enable Testability: No
- Optimization Level: Optimize for Speed [-O]
- Swift Optimization Level: Optimize for Speed [-O]
```

### Asset Catalog Setup

#### App Icons (AppIcon.appiconset)
Required sizes:
- 1024×1024 (App Store)
- 60×60 @2x, @3x (iPhone App)
- 76×76 @1x, @2x (iPad App)
- 83.5×83.5 @2x (iPad Pro)
- 40×40 @2x, @3x (iPhone/iPad Spotlight)
- 29×29 @2x, @3x (iPhone/iPad Settings)
- 20×20 @2x, @3x (iPhone/iPad Notification)

#### Launch Screen
- Uses `LaunchScreen.storyboard` or SwiftUI `LaunchScreen`
- Background: System background color
- Simple app icon or loading indicator
- No text that requires localization

### Privacy Permissions (Info.plist)

Required usage descriptions are already in Info.plist:
```xml
<key>NSUserNotificationsUsageDescription</key>
<string>Fasting Tracker needs permission to send notifications to remind you about fasting milestones and help you stay on track with your goals.</string>

<key>NSFaceIDUsageDescription</key>
<string>Use Face ID or Touch ID to securely access your personal fasting profile and data.</string>

<key>NSContactsUsageDescription</key>
<string>Access your contacts to easily add friends and share your fasting journey with people you know.</string>
```

### File Organization

```
FastingTracker/
├── App/
│   ├── FastingTrackerApp.swift
│   ├── Info.plist
│   └── Assets.xcassets
├── Models/
│   ├── FastingSession.swift
│   ├── UserProfile.swift
│   ├── Friend.swift
│   ├── MoodEntry.swift
│   └── CoreFastingStage.swift
├── Views/
│   ├── MainTabView.swift
│   ├── HomeView.swift
│   ├── FriendsView.swift
│   ├── ProfileView.swift
│   ├── LearnView.swift
│   ├── CoreNotificationsView.swift
│   └── OnboardingView.swift
├── Managers/
│   ├── FastingManager.swift
│   ├── NotificationManager.swift
│   ├── AuthenticationManager.swift
│   └── ErrorHandler.swift
├── Utilities/
│   ├── CoreShareManager.swift
│   ├── AccessibilityHelper.swift
│   └── LearnArticle.swift
├── Tests/
│   ├── FastingTrackerTests.swift
│   └── FastingTrackerUITests.swift
└── Documentation/
    ├── AppStore-Metadata.md
    └── PrivacyPolicy.md
```

### Build Phases Configuration

#### Compile Sources
All .swift files should be included automatically

#### Link Binary with Libraries
System frameworks are linked automatically with SwiftUI

#### Copy Bundle Resources
- Assets.xcassets
- Info.plist
- Any localization files

### Scheme Configuration

#### Fasting Tracker Scheme
```
Build Configuration:
- Run: Debug
- Test: Debug  
- Profile: Release
- Analyze: Debug
- Archive: Release

Arguments & Environment:
- No special launch arguments needed
- Environment variables for debugging (optional):
  - OS_ACTIVITY_MODE: disable (to reduce console noise)
```

### Version Control (.gitignore)
```
# Xcode
*.xcworkspace/xcuserdata/
*.xcodeproj/xcuserdata/
*.xcodeproj/project.xcworkspace/xcuserdata/

# Build products
build/
DerivedData/

# Provisioning profiles
*.mobileprovision

# Code signing
*.p12

# macOS
.DS_Store

# Swift Package Manager
.swiftpm/

# Fastlane
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots
fastlane/test_output
```

### Testing Configuration

#### Unit Tests
- Target: FastingTrackerTests
- Framework: Swift Testing (new testing framework)
- Host app: Fasting Tracker
- Code coverage: Enabled

#### UI Tests  
- Target: FastingTrackerUITests
- Test runner: XCTest
- Target app: Fasting Tracker

### Archive & Distribution

#### Development
1. Ensure development provisioning profile is selected
2. Build and test on device
3. Run unit and UI tests

#### App Store Distribution
1. Set Release build configuration
2. Select distribution provisioning profile  
3. Archive the project
4. Upload to App Store Connect
5. Submit for review

### Performance Optimization

#### Release Build Optimizations
- Whole Module Optimization enabled
- Dead code stripping enabled
- Swift optimization level: -O (speed)
- Strip debug symbols: Yes

#### Memory Management
- ARC enabled (automatic)
- SwiftData handles Core Data memory management
- Proper @State and @Bindable usage in SwiftUI

### Accessibility
- VoiceOver support implemented via AccessibilityHelper
- Dynamic Type support
- High contrast color support
- Reduce Motion support

### Localization (Future)
Ready for localization:
- String literals should be wrapped in NSLocalizedString()
- Storyboards support localization
- Asset catalog supports localized images

### App Store Optimization
- App Store metadata prepared in AppStore-Metadata.md
- Privacy Policy created
- Screenshot requirements documented
- App description optimized for search

This configuration ensures your Fasting Tracker app will build, run, and be ready for App Store submission following Apple's best practices and guidelines.