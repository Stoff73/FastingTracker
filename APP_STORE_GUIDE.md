# FastingTracker — App Store Deployment Guide

Complete step-by-step guide to submit FastingTracker to the App Store.

---

## Prerequisites

- **Apple Developer Program membership** ($99/year) — [developer.apple.com/programs](https://developer.apple.com/programs/)
- **Xcode 16+** installed on a Mac
- **Apple ID** signed into Xcode (Xcode → Settings → Accounts)
- Team: `CHRISTOPHER JOHN SLATER-JONES`
- Bundle ID: `CSJ.FastingTracker`
- Privacy policy publicly hosted (see Part 0 below)

---

## Part 0: Host the Privacy Policy

Apple requires a live, accessible privacy policy URL before you can submit.

### Option A — GitHub Pages (recommended, free)

1. The `PrivacyPolicy.md` is already committed to the repo
2. In your GitHub repo settings, go to **Pages** → Source → **Deploy from branch** → `main`
3. Enable GitHub Pages — your privacy policy will be at:
   `https://stoff73.github.io/FastingTracker/PrivacyPolicy`
4. Or convert `PrivacyPolicy.md` to a simple HTML page and commit it as `docs/privacy.html`

### Option B — Any web host

Upload `PrivacyPolicy.md` (or convert to HTML) to any URL you control. Copy the URL — you'll need it in Part 3.

---

## Part 1: Configure the Project in Xcode

### 1.1 Open the Project
```bash
open FastingTracker.xcodeproj
```

### 1.2 Set Signing & Capabilities
1. Click **FastingTracker** in the project navigator (blue icon)
2. Select the **FastingTracker** target (under TARGETS)
3. Go to **Signing & Capabilities** tab
4. Tick **Automatically manage signing**
5. Set **Team** to `CHRISTOPHER JOHN SLATER-JONES`
6. Confirm **Bundle Identifier** is `CSJ.FastingTracker`
   - If the ID is already taken by another developer, change it to something unique, e.g. `com.chrisslater.fastingtracker`, then register that new ID in Part 2.2

### 1.3 Set the Version and Build Number
1. Go to **General** tab of the FastingTracker target
2. Set **Version** → `1.0.0`
3. Set **Build** → `1`
   - Increment **Build** (not Version) every time you upload a new binary to App Store Connect

### 1.4 Verify Deployment Target
- **General** → **Minimum Deployments** → **iOS 17.0** (already configured)

### 1.5 Verify Privacy Manifest is Included
The file `FastingTracker/PrivacyInfo.xcprivacy` is already in the project and will be automatically bundled by Xcode's file system sync. No manual action needed — Xcode 16 picks it up automatically.

To confirm: **Product** → **Archive**, then in the Organizer click the archive → **Distribute App** → at the privacy manifest review screen you should see the manifest listed.

### 1.6 Check the App Icon
1. Open `Assets.xcassets` → click **AppIcon**
2. Replace with a custom 1024×1024 PNG if needed (drag it onto the iOS 1024pt slot)
3. Apple rejects apps with default/placeholder icons

---

## Part 2: Create the App in App Store Connect

### 2.1 Log In
Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com) and sign in.

### 2.2 Register the Bundle ID (first time only)
1. Go to [developer.apple.com → Certificates, IDs & Profiles → Identifiers](https://developer.apple.com/account/resources/identifiers/list)
2. Click **+** → **App IDs** → **App** → Continue
3. Fill in:
   - **Description**: Fasting Tracker
   - **Bundle ID**: Explicit → `CSJ.FastingTracker`
4. Under **Capabilities**, enable:
   - **Push Notifications**
5. Click **Continue** → **Register**

> Note: Face ID does not need a separate capability toggle here — it's enabled via the `NSFaceIDUsageDescription` key already set in the project's build settings.

### 2.3 Create the App Listing
1. App Store Connect → **My Apps** → **+** → **New App**
2. Fill in:
   - **Platforms**: iOS
   - **Name**: `Fasting Tracker` (spaces allowed; must be unique on the App Store)
   - **Primary Language**: English (U.K.) or English (U.S.)
   - **Bundle ID**: `CSJ.FastingTracker`
   - **SKU**: `fasting-tracker-v1` (internal only, never shown to users)
   - **User Access**: Full Access
3. Click **Create**

---

## Part 3: Prepare App Store Metadata

### 3.1 Screenshots (Required)

> **IMPORTANT**: You must use a simulator that exactly matches the required display size slots in App Store Connect. Using the wrong simulator (e.g. iPhone 17 Pro or iPhone 16e) produces the wrong resolution and App Store Connect will reject them.

| App Store Slot | Simulator to Use | Resolution |
|---------------|-----------------|------------|
| **6.9"** — **Required** | **iPhone 16 Pro Max** | 1320 × 2868 px |
| 6.7" — Recommended | iPhone 15 Plus or iPhone 14 Plus | 1290 × 2796 px |
| 6.5" — Recommended | iPhone 11 Pro Max | 1242 × 2688 px |
| iPad Pro 13" — If iPad supported | iPad Pro 13-inch (M4) | 2064 × 2752 px |

Do NOT use iPhone 17 Pro (6.3") or iPhone 16e (4.7") for screenshots — neither matches a required slot.

**How to capture:**
1. In Xcode, change the run destination to **iPhone 16 Pro Max**
   - If it's not listed: **Window** → **Devices and Simulators** → **Simulators** tab → **+** → search "iPhone 16 Pro Max" → add it
2. Run the app (**Cmd+R**)
3. Navigate to each screen you want to capture
4. Press **Cmd+S** in the Simulator — screenshot saves to your **Desktop**
5. Repeat for all screens, then upload to App Store Connect under the **6.9"** slot

**Recommended screens to capture:**
1. Home – idle (before starting a fast)
2. Home – active fast with progress ring and stage label
3. End Fast summary modal
4. Fasting history sheet
5. Learn tab
6. Profile tab

### 3.2 App Information

| Field | Value |
|-------|-------|
| **Name** | Fasting Tracker |
| **Subtitle** | Intermittent Fasting Timer |
| **Category** | Health & Fitness |
| **Secondary Category** | Lifestyle |
| **Content Rights** | Does not contain third-party content |
| **Age Rating** | 4+ (answer "None" to all questionnaire items) |

### 3.3 Description & Keywords

**Description** (paste into the Version Information → Description field):
```
Track your intermittent fasting journey with Fasting Tracker. A beautiful circular progress timer shows exactly which fasting stage you're in — from digestion through fat burning, ketosis, autophagy, and deep cleanse.

FEATURES

• Real-time fasting timer with circular progress ring
• Fasting stage tracking — see what your body is doing right now
• Mood check-in throughout your fast
• Save and review your fasting history with streaks and personal records
• Share fasting milestones to social media
• Add friends and fast together
• Learning centre with fasting science, tips, and safety information
• Milestone notifications to keep you motivated
• Face ID / Touch ID profile protection
• All data stored locally on your device — nothing leaves your phone

Supports 16:8, 18:6, 20:4, OMAD, and any custom fasting goal.
```

**Keywords** (max 100 characters, comma-separated):
```
fasting,intermittent,timer,ketosis,autophagy,16:8,health,diet,tracker,fast
```

**Promotional Text** (updatable without a new build):
```
Track your fast. Know your stage. Fast with friends.
```

**Support URL**: Your privacy policy / GitHub Pages URL (required)

**Privacy Policy URL**: The hosted `PrivacyPolicy.md` URL from Part 0

### 3.4 App Privacy Nutrition Labels

In App Store Connect → Your App → **App Privacy** tab:

1. Click **Get Started**
2. **"Do you collect data from this app?"** → **Yes**
3. Add these data types (matching `PrivacyInfo.xcprivacy`):

| Data Type | Purpose | Linked to Identity | Used for Tracking |
|-----------|---------|-------------------|-------------------|
| **Health & Fitness** (fasting session durations, stages, targets) | App Functionality | No | No |
| **Other User Content** (mood emoji selections, fast notes) | App Functionality | No | No |
| **Name** (display name entered during onboarding) | App Functionality | No | No |

4. For each type, select:
   - **Used for**: App Functionality only
   - **Is this data linked to the user's identity?** → No
   - **Is this data used for tracking?** → No
5. Click **Publish**

> These labels must match the `PrivacyInfo.xcprivacy` manifest already bundled in the app. They do.

---

## Part 4: Archive & Upload

### 4.1 Select the Right Destination
1. In Xcode, confirm the scheme is **FastingTracker**
2. Click the device dropdown → select **Any iOS Device (arm64)** — NOT a simulator
3. "Archive" is greyed out when a simulator is selected

### 4.2 Archive the App
1. **Product** → **Archive**
2. Build takes 1–3 minutes
3. The **Organizer** window opens automatically on completion

### 4.3 Validate (Recommended Before Uploading)
1. Select the archive in the Organizer
2. Click **Validate App**
3. Follow the prompts (same as distribute, but doesn't upload)
4. Fix any errors before uploading

### 4.4 Upload to App Store Connect
1. Select the archive → **Distribute App**
2. Select **App Store Connect** → **Next**
3. Select **Upload** → **Next**
4. Leave these checked:
   - ✅ Upload your app's symbols
   - ✅ Manage Version and Build Number
5. If asked about the privacy manifest, review and confirm
6. Select your **Distribution Certificate** and **Provisioning Profile**
   - With automatic signing, Xcode handles this automatically
7. Click **Upload**
8. Wait 2–5 minutes for the upload to complete

### 4.5 Common Upload Failures

| Error | Fix |
|-------|-----|
| "No accounts with App Store Connect access" | Xcode → Settings → Accounts → re-sign in |
| "No suitable application records found" | Bundle ID in Xcode doesn't match App Store Connect |
| "Missing compliance" | Answer the encryption question in TestFlight (see 5.2) |
| Provisioning profile errors | Xcode → Settings → Accounts → team → Download Manual Profiles |
| "Invalid privacy manifest" | Ensure `PrivacyInfo.xcprivacy` is inside `FastingTracker/` (it is) |

---

## Part 5: TestFlight (Beta Testing)

### 5.1 Wait for Processing
1. App Store Connect → Your App → **TestFlight** tab
2. Build shows as **Processing** — takes 5–30 minutes
3. You receive an email when ready

### 5.2 Export Compliance
When processing completes:
1. Click the build → **Manage** next to "Missing Compliance"
2. **"Does your app use encryption?"** → **No**
   - Fasting Tracker does not use custom encryption algorithms
   - Standard HTTPS handled by the OS does not count
3. Save

### 5.3 Internal Testing (no Apple review required)
1. TestFlight → **Internal Testing** → **+** to create a group
2. Add up to 100 testers by Apple ID
3. Select the build
4. Testers get an email invite and install via the **TestFlight** app

### 5.4 External Testing (up to 10,000 testers)
1. TestFlight → **External Testing** → **+** to create a group
2. Add testers by email or create a public link
3. Fill in **What to Test** and a contact email
4. **Submit for Review** — Apple reviews in 24–48 hours
5. Once approved, testers are notified

### 5.5 Tester Instructions
```
1. Install "TestFlight" from the App Store (free, made by Apple)
2. Open the invite email on your iPhone
3. Tap "View in TestFlight" → "Accept" → "Install"
```

---

## Part 6: Submit to the App Store (Production)

### 6.1 Checklist Before Submitting

- ✅ Screenshots uploaded (6.9" required)
- ✅ Description filled in
- ✅ Keywords set
- ✅ Category: Health & Fitness
- ✅ Age rating: 4+
- ✅ App Privacy nutrition labels completed
- ✅ Support URL provided (required)
- ✅ Privacy Policy URL provided (required)
- ✅ A build is linked to the version

### 6.2 Submit
1. App Store Connect → Your App → **App Store** tab
2. Under **Build**, click **+** → select your uploaded build
3. Click **Add for Review** (top right)
4. Answer the submission questions:
   - **Sign-in required?** → Yes — provide a demo account OR select "None required" and explain it uses local onboarding
     > Fasting Tracker uses an onboarding flow, not a server-side login. Select "None" and note that the app creates a local profile on first launch.
   - **Content rights** → I own all rights to this content
   - **Advertising Identifier (IDFA)** → No
5. **Submit to App Review**

### 6.3 Review Timeline
- Typical: **24–48 hours** (often same day)
- You'll receive an email for approval or rejection
- If rejected: read the reason, fix it, upload a new build (increment build number), resubmit

### 6.4 Common Rejection Reasons

| Reason | Fix |
|--------|-----|
| Crashes on launch | Test on a real device, not just simulator |
| Incomplete features | Ensure all tabs and buttons work correctly |
| Missing privacy policy | Must be a live URL, not a GitHub file preview |
| Health claims | Describe features, not medical benefits |
| Placeholder data / test accounts | Remove any hardcoded test content |
| Privacy labels mismatch | Labels must match `PrivacyInfo.xcprivacy` (they do) |

---

## Part 7: Post-Launch

### 7.1 Releasing an Update
1. Make code changes
2. **Increment Build number** (e.g., 1 → 2) — required for every upload
3. Increment Version number for user-visible changes (e.g., 1.0.0 → 1.0.1)
4. Archive → Upload → App Store Connect → create new version or add build → Submit

### 7.2 Version Numbering Convention
- **Version** (CFBundleShortVersionString): User-visible. `MAJOR.MINOR.PATCH`
  - `1.0.0` → initial release
  - `1.0.1` → bug fixes
  - `1.1.0` → new features
- **Build** (CFBundleVersion): Must be unique per upload. Increment every time.

### 7.3 Monitoring
- **App Store Connect → Analytics**: Downloads, sessions, retention
- **Xcode → Organizer → Crashes**: Symbolicated crash reports from users
- **TestFlight → Feedback**: Screenshots and notes from beta testers

---

## Part 8: Git — Push Pending Commits

There are 3 commits pending push to GitHub:

```bash
# From terminal (not this environment — requires GitHub credentials):
git push

# If HTTPS auth fails, switch to SSH:
git remote set-url origin git@github.com:Stoff73/FastingTracker.git
git push
```

Commits to push:
- `c08c620` — Fix stability issues and add polish (original)
- `ad5980c` — Add save/discard fast flow, fasting history, and sharing
- `8e5dad5` — Add PrivacyInfo.xcprivacy privacy manifest and App Store preparation

---

## Quick Reference: Complete Deployment in 10 Steps

1. Host `PrivacyPolicy.md` at a public URL (GitHub Pages is easiest)
2. Open project in Xcode → set signing team → confirm bundle ID `CSJ.FastingTracker`
3. Register bundle ID at developer.apple.com
4. Create app listing in App Store Connect
5. Fill in metadata: description, keywords, screenshots, support URL, privacy policy URL
6. Complete App Privacy nutrition labels (Health & Fitness, User Content, Name — all local/unlinked)
7. In Xcode: set destination → **Any iOS Device** → **Product** → **Archive**
8. In Organizer: **Distribute App** → **App Store Connect** → **Upload**
9. In App Store Connect → **TestFlight**: answer encryption question, add testers, test
10. When ready: **App Store** tab → link build → **Submit to App Review** → wait for approval
