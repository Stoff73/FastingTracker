# FastingTracker — App Store Publishing Guide

This is a step-by-step guide to get FastingTracker published on the App Store via TestFlight (for testing) and then to production.

---

## Prerequisites

- **Apple Developer Program membership** ($99/year) — [developer.apple.com/programs](https://developer.apple.com/programs/)
- **Xcode 15+** installed
- **Apple ID** signed into Xcode (Xcode → Settings → Accounts)
- Your team ID is `99S3M8JLLF` — if this is already enrolled, you're good to go

---

## Part 1: Configure the Project in Xcode

### 1.1 Open the Project
```
open FastingTracker.xcodeproj
```

### 1.2 Set Signing & Capabilities
1. Click **FastingTracker** in the project navigator (blue icon, top left)
2. Select the **FastingTracker** target (under TARGETS, not PROJECT)
3. Go to the **Signing & Capabilities** tab
4. Tick **Automatically manage signing**
5. Set **Team** to your Apple Developer team
6. Verify **Bundle Identifier** is `CSJ.FastingTracker`
   - If it shows an error saying the ID is taken, change it to something unique like `com.chrisslater.fastingtracker`
   - If you change it, update it in both Debug and Release configurations

### 1.3 Set the Version Number
1. Still on the **General** tab of the FastingTracker target
2. Set **Version** to `1.0.0`
3. Set **Build** to `1`
   - Increment the Build number each time you upload a new build to TestFlight

### 1.4 Verify Deployment Target
1. Under **General** → **Minimum Deployments**
2. Should be set to **iOS 17.0** (already configured)

### 1.5 Check the App Icon
1. Open `Assets.xcassets` in the project navigator
2. Click **AppIcon** — you should see the generated icon with the progress ring design
3. If you want to replace it with a custom design, drop a 1024x1024 PNG into the iOS slot

---

## Part 2: Create the App in App Store Connect

### 2.1 Log In
1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
2. Sign in with your Apple ID (the one enrolled in the Developer Program)

### 2.2 Register the Bundle ID (if not done)
1. Go to [developer.apple.com/account/resources/identifiers](https://developer.apple.com/account/resources/identifiers/list)
2. Click the **+** button
3. Select **App IDs** → Continue
4. Select **App** → Continue
5. Enter:
   - **Description**: FastingTracker
   - **Bundle ID**: Explicit → `CSJ.FastingTracker` (or whatever you set in Xcode)
6. Under **Capabilities**, enable:
   - **Push Notifications** (for fasting reminders)
   - **Face ID** (listed as "FaceID" — for profile lock)
7. Click **Continue** → **Register**

### 2.3 Create the App Listing
1. Back in App Store Connect, go to **My Apps**
2. Click the **+** button → **New App**
3. Fill in:
   - **Platforms**: iOS
   - **Name**: FastingTracker (or "Fasting Tracker" — must be unique on the App Store)
   - **Primary Language**: English (UK) or English (US)
   - **Bundle ID**: Select `CSJ.FastingTracker` from the dropdown
   - **SKU**: `fastingtracker` (any unique string, internal use only)
   - **User Access**: Full Access
4. Click **Create**

---

## Part 3: Prepare App Store Metadata

You'll need these before you can submit. Fill them in on the App Store Connect app page.

### 3.1 Screenshots (Required)
You need screenshots for at least:
- **6.7" display** (iPhone 15 Pro Max / 16 Pro Max) — 1290 x 2796 pixels
- **6.5" display** (iPhone 11 Pro Max) — 1242 x 2688 pixels (optional but recommended)
- **iPad Pro 12.9"** — 2048 x 2732 pixels (if supporting iPad)

**How to take screenshots:**
1. Run the app in the Simulator on the correct device
2. Press **Cmd+S** in the Simulator to save a screenshot to your Desktop
3. Take screenshots of: Home screen (idle), Home screen (fasting), Friends tab, Learn tab, Profile tab
4. Upload 3-10 screenshots per device size in App Store Connect

### 3.2 App Information
Fill in on the app page in App Store Connect:

| Field | Value |
|-------|-------|
| **Subtitle** | Intermittent Fasting Timer |
| **Category** | Health & Fitness |
| **Secondary Category** | Lifestyle |
| **Content Rights** | Does not contain third-party content |
| **Age Rating** | Click "Edit" and answer the questionnaire (all "None" — no objectionable content) |

### 3.3 App Privacy
Go to **App Privacy** tab in App Store Connect:
1. Click **Get Started**
2. Select **Yes, we collect data** (the app stores fasting sessions locally)
3. Data types collected:
   - **Health & Fitness** → Fasting data (used for app functionality, not tracked)
   - **Contact Info** → Phone number (for Friends feature, not tracked)
4. For each type, specify:
   - **Used for**: App Functionality
   - **Linked to identity**: No
   - **Tracking**: No

### 3.4 Description & Keywords
Use these in the **Version Information** section:

**Description:**
```
Track your intermittent fasting journey with FastingTracker. Watch your progress in real-time with a beautiful circular timer that shows exactly which fasting stage you're in — from digestion through fat burning, ketosis, autophagy, and deep cleanse.

Features:
• Visual fasting timer with stage-by-stage progress tracking
• Learn what's happening in your body at each fasting stage
• Track your mood throughout your fast
• Add friends and fast together — see each other's progress
• Comprehensive learning centre with fasting science, tips, and safety info
• Share your fasting milestones on social media
• Face ID protection for your profile
• Fasting history with streaks and personal records
• Milestone notifications to keep you motivated
• All data stored locally on your device — your data stays yours

Whether you're doing 16:8, 20:4, or extended fasts, FastingTracker helps you understand what your body is going through and keeps you motivated every step of the way.
```

**Keywords** (100 character limit, comma-separated):
```
fasting,intermittent,timer,health,ketosis,autophagy,weight,diet,tracker,16:8
```

**Promotional Text** (can be updated without a new build):
```
Track your fast. Understand your body. Fast with friends.
```

**Support URL**: Your website or a GitHub pages link
**Marketing URL**: Optional

---

## Part 4: Archive & Upload

### 4.1 Set Build Configuration
1. In Xcode, set the **scheme** to **FastingTracker**
2. Set the **destination** to **Any iOS Device (arm64)** — NOT a simulator
   - Click the device dropdown at the top and select it

### 4.2 Create an Archive
1. Go to **Product** → **Archive** (menu bar)
2. Wait for the build to complete (1-3 minutes)
3. The **Organizer** window opens automatically when done

If "Archive" is greyed out, make sure the destination is set to "Any iOS Device", not a simulator.

### 4.3 Upload to App Store Connect
1. In the Organizer, select your new archive
2. Click **Distribute App**
3. Select **App Store Connect** → **Next**
4. Select **Upload** → **Next**
5. Leave all options checked:
   - ✅ Upload your app's symbols
   - ✅ Manage Version and Build Number
6. Select your **Distribution Certificate** and **Provisioning Profile**
   - If using automatic signing, Xcode handles this for you
7. Click **Upload**
8. Wait for the upload to complete (2-5 minutes depending on connection)

### 4.4 If Upload Fails
Common issues:
- **"No accounts with App Store Connect access"** → Check Xcode → Settings → Accounts
- **"No suitable application records found"** → The bundle ID in Xcode doesn't match App Store Connect
- **"Missing compliance"** → See step 5.2 below
- **Provisioning profile errors** → Go to Xcode → Settings → Accounts → your team → Download Manual Profiles

---

## Part 5: TestFlight (Beta Testing)

### 5.1 Wait for Processing
1. After upload, go to App Store Connect → Your App → **TestFlight** tab
2. The build will show as **Processing** — this takes 5-30 minutes
3. You'll get an email when it's ready

### 5.2 Export Compliance
When the build finishes processing:
1. Click on the build number
2. You'll see a yellow **"Missing Compliance"** warning
3. Click **Manage** next to it
4. Answer: **"Does your app use encryption?"** → **No**
   - FastingTracker doesn't use any custom encryption
   - (HTTPS doesn't count — Apple means custom encryption algorithms)
5. Click **Save**

### 5.3 Internal Testing (Immediate, No Review)
1. Go to **TestFlight** → **Internal Testing**
2. Click **+** next to "Internal Testers" to create a group
3. Name it (e.g., "Core Team")
4. Add testers by Apple ID email (up to 100 people)
5. Select the build to test
6. Testers receive an email invite immediately
7. They install **TestFlight** from the App Store, accept the invite, and download the app

### 5.4 External Testing (Up to 10,000 Testers)
1. Go to **TestFlight** → **External Testing**
2. Click **+** to create a group
3. Add testers by email OR create a **public link** anyone can use
4. Fill in:
   - **What to Test**: Describe what testers should focus on
   - **Contact Email**: Your email for feedback
5. Click **Submit for Review**
6. Apple reviews external TestFlight builds (usually approved within 24-48 hours)
7. Once approved, testers get the invite

### 5.5 Tell Testers What To Do
Share this with your testers:
```
1. Install "TestFlight" from the App Store (it's free, made by Apple)
2. Open the invite email on your iPhone
3. Tap "View in TestFlight"
4. Tap "Accept" then "Install"
5. The app appears on your home screen like any other app
```

---

## Part 6: Submit to the App Store (Production)

Only do this when you're happy with TestFlight testing.

### 6.1 Prepare for Submission
1. In App Store Connect → Your App → **App Store** tab
2. Make sure all required fields are filled:
   - ✅ Screenshots uploaded
   - ✅ Description written
   - ✅ Category set
   - ✅ Age rating completed
   - ✅ App privacy filled in
   - ✅ Support URL provided
3. Under **Build**, click **+** and select your uploaded build

### 6.2 Submit
1. Click **Add for Review** (top right)
2. Answer the submission questions:
   - **Sign-in required?** → No (the app doesn't require login)
   - **Content rights** → Yes, I own the rights
   - **Advertising Identifier (IDFA)** → No (we don't use it)
3. Click **Submit to App Review**

### 6.3 App Review Timeline
- **Typical review time**: 24-48 hours (can be as fast as a few hours)
- You'll get an email when the review is complete
- If **rejected**, they'll tell you why. Fix the issue, upload a new build, and resubmit
- If **approved**, you can release immediately or schedule a release date

### 6.4 Common Rejection Reasons (and How to Avoid Them)
| Reason | Solution |
|--------|----------|
| Crashes or bugs | Test thoroughly on TestFlight first |
| Incomplete features | Make sure all tabs/buttons work |
| Missing privacy policy | Add a Support URL with a privacy policy |
| Placeholder content | Remove any "lorem ipsum" or test data |
| Health claims | Don't claim the app treats or cures any condition |

---

## Part 7: Post-Launch

### 7.1 Updating the App
1. Make code changes
2. Increment the **Build** number in Xcode (e.g., 1 → 2)
3. Archive and upload again
4. In App Store Connect, create a new version or update the existing one
5. Submit for review

### 7.2 Version Numbers
- **Version** (e.g., 1.0.0): User-facing, shown on the App Store. Increment for feature releases.
- **Build** (e.g., 1, 2, 3): Internal, must be unique per upload. Increment every time you upload.

### 7.3 Monitoring
- **App Store Connect → Analytics**: Downloads, sessions, crashes
- **Xcode → Organizer → Crashes**: View crash reports from users
- **TestFlight → Feedback**: Testers can send screenshots and notes from inside TestFlight

---

## Quick Reference: The Whole Process in 10 Steps

1. Sign into Xcode with your Apple Developer account
2. Set signing & capabilities in the project
3. Register Bundle ID at developer.apple.com
4. Create the app in App Store Connect
5. Fill in metadata (description, screenshots, privacy)
6. In Xcode: set destination to "Any iOS Device" → Product → Archive
7. In Organizer: Distribute App → App Store Connect → Upload
8. In App Store Connect: TestFlight → add testers → test
9. When ready: App Store tab → select build → Submit to App Review
10. Wait for approval → Release
