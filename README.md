# SomaFM Miniplayer

A native macOS menu bar app for streaming SomaFM radio channels, built with Swift and SwiftUI. This app provides quick access to all SomaFM channels directly from your menu bar, with native Apple Silicon support.

## Features

- 🎵 Stream all SomaFM channels directly from the menu bar
- 🎮 Simple controls: left-click to play/pause, right-click for channel menu
- 📊 Channels sorted by listener count (most popular first)
- 🎶 Display currently playing song with real-time updates
- 🔍 Search current song in Apple Music or YouTube with one click
- 💾 Offline channel caching for reliability
- 🎯 Native Apple Silicon (M1/M2/M3) support
- 🔄 Automatic stream recovery on network interruptions

## Requirements

- macOS 11.0 (Big Sur) or later
- Xcode 13 or later (for building from source)

## Installation

### Building from Source

1. Clone this repository
2. Open `SomaFM miniplayer.xcodeproj` in Xcode
3. Select your development team in the project settings
4. Build and run (⌘+R)

## Usage

### Controls

- **Left-click** the menu bar icon: Play/pause the current stream
- **Right-click** the menu bar icon: Show channel selection menu

### First Use

1. Right-click the menu bar icon to see available channels
2. Select a channel to start streaming
3. The icon changes to indicate playback state:
   - ▶️ Play icon: No stream playing or paused
   - ⏸️ Pause icon: Stream is playing

### Menu Options

The right-click menu displays:
- **Now Playing section** (when streaming):
  - Current channel name
  - Currently playing song with 🔍 icon (click to search)
- **Channel list**:
  - All available SomaFM channels (sorted by popularity)
  - Current listener count in tooltips
  - Currently playing channel marked with a checkmark
- **Controls**:
  - Play/Pause control for the current stream
  - Quit option

### Song Search

When a song is playing:
1. Click on the song title in the menu
2. Choose to search in:
   - **Apple Music**: Opens in the Music app (or web if not installed)
   - **YouTube**: Opens search results in your default browser

## Architecture

- **SwiftUI** for the user interface
- **AVFoundation** for audio streaming
- **Combine** for reactive state management
- **AppKit** for menu bar integration

## License

This project is provided as-is for educational purposes. SomaFM is a registered trademark of SomaFM.com, LLC. This app is not affiliated with or endorsed by SomaFM.

## Acknowledgments

- [SomaFM](https://somafm.com) for providing excellent commercial-free radio
- Inspired by the original SomaFM miniplayer