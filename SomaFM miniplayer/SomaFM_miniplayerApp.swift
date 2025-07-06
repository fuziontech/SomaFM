//
//  SomaFM_miniplayerApp.swift
//  SomaFM miniplayer
//
//  Created by James Greenhill on 7/5/25.
//

import SwiftUI
import AppKit

@main
struct SomaFM_miniplayerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    var audioPlayer: AudioPlayer!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "play.circle", accessibilityDescription: "SomaFM Player")
            button.action = #selector(togglePopover(_:))
        }
        
        // Create the popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ChannelListView())
        
        // Initialize audio player
        audioPlayer = AudioPlayer.shared
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    
    func updateStatusIcon(isPlaying: Bool) {
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: isPlaying ? "pause.circle" : "play.circle", 
                                 accessibilityDescription: isPlaying ? "Pause" : "Play")
        }
    }
}