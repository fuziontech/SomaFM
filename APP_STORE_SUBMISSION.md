# App Store Submission Guide

## Pre-Submission Checklist

### 1. Apple Developer Setup
- [ ] Create Apple Developer account ($99/year)
- [ ] Create App ID in developer portal
- [ ] Create Mac App Distribution certificate
- [ ] Create Mac App Store provisioning profile

### 2. Xcode Project Configuration

1. **Open project in Xcode**
2. **Select project → Target → Signing & Capabilities**
   - Team: Select your developer team
   - Bundle Identifier: `com.yourcompany.somafm-player` (must be unique)
   - Signing Certificate: Mac App Distribution

3. **Add App Sandbox capability**
   - Check: Outgoing Connections (Client)
   - Remove: Incoming Connections
   - Remove: Audio Input

4. **Update Build Settings**
   - Product Name: SomaFM Player
   - Build Number: Increment for each upload
   - Deployment Target: macOS 11.0

### 3. App Icons

You need to provide app icons in these sizes:
- 16x16
- 32x32
- 64x64
- 128x128
- 256x256
- 512x512
- 1024x1024

Add them to `Assets.xcassets/AppIcon.appiconset/`

### 4. App Store Connect Setup

1. **Create New App**
   - Sign in to [App Store Connect](https://appstoreconnect.apple.com)
   - Click "+" → "New App"
   - Platform: macOS
   - Name: SomaFM Player
   - Primary Language: English
   - Bundle ID: Select your bundle ID (e.g., com.droptables.somafm-player)
   - SKU: somafm-player-001
   - Company: Drop Tables Software, LLC

2. **App Information**
   - Category: Music
   - Content Rights: Third-party content (SomaFM streams)
   - Age Rating: 4+ (no objectionable content)

3. **Pricing and Availability**
   - Price: Free
   - Available in all territories

### 5. App Store Metadata

**Description:**
```
SomaFM Player brings the best of internet radio to your Mac's menu bar. Access over 30 unique channels of listener-supported, commercial-free radio with just a click.

Features:
• Quick access from menu bar - no window clutter
• Native Apple Silicon support for optimal performance
• View currently playing track information
• Search songs in Apple Music or YouTube
• Offline channel caching
• Automatic stream recovery
• Beautiful native macOS interface

From Deep Space ambient to Groove Salad's downtempo beats, discover hand-curated music you won't find anywhere else.

SomaFM Player is not affiliated with SomaFM but is a third-party client for their streaming service.
```

**Keywords:**
`somafm,radio,streaming,music,ambient,electronic,internet radio,menu bar,indie,underground`

**Screenshots Required:**
1. Menu bar with channel list open
2. Now playing view with song info
3. Channel selection
4. Play/pause states
5. Song search options

### 6. Legal Requirements

**Privacy Policy URL:** Required (even if app doesn't collect data)

**Sample Privacy Policy:**
```
SomaFM Player does not collect any personal information. 
The app only connects to SomaFM's public API to retrieve channel and song information.
No user data is stored or transmitted to any servers.
```

### 7. Archive and Upload

1. **In Xcode:**
   - Product → Archive
   - Distribute App → App Store Connect → Upload
   - Automatically manage signing
   - Upload to App Store Connect

2. **In App Store Connect:**
   - Select build for review
   - Submit for review

### 8. Review Notes

**Add these review notes:**
```
This is a third-party client for SomaFM internet radio service. 
The app streams publicly available radio channels from SomaFM.com.
All content is provided by SomaFM under their terms of service.
The app lives in the menu bar and has no main window (LSUIElement is set to true).
```

## Common Rejection Reasons to Avoid

1. **Copyright**: Make it clear this is a third-party app
2. **Network Security**: We've already configured proper ATS exceptions
3. **Sandbox Violations**: Ensure only required entitlements are enabled
4. **Incomplete Metadata**: Fill out all required fields

## Post-Submission

- Review typically takes 24-48 hours
- Be ready to respond to reviewer questions
- Have a plan for updates and bug fixes

## Important Considerations

### Licensing and Legal
- Contact SomaFM for permission to use their name/service
- Consider alternative names like "Menu Bar Radio Player for SomaFM"
- Add disclaimers about third-party status

### Monetization Options
- Keep it free (recommended)
- Tip jar (in-app purchase)
- Pro version with extra features

### Future Features for Updates
- Favorites/bookmarks
- Sleep timer
- Keyboard shortcuts
- Custom themes
- Notification Center integration