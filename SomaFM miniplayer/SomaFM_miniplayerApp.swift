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
    var audioPlayer: AudioPlayer!
    var menu: NSMenu!
    var menuManager: MenuManager!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "play.circle", accessibilityDescription: "SomaFM Player")
            button.action = #selector(handleClick(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        // Initialize managers
        audioPlayer = AudioPlayer.shared
        menuManager = MenuManager.shared
    }
    
    @objc func handleClick(_ sender: Any?) {
        guard let event = NSApp.currentEvent else { return }
        
        if event.type == .rightMouseUp {
            // Right click - show channel menu
            showChannelMenu()
        } else if event.type == .leftMouseUp {
            // Left click - play/pause only
            if audioPlayer.isPlaying {
                audioPlayer.pause()
            } else if audioPlayer.currentChannel != nil {
                audioPlayer.resume()
            }
            // Do nothing if no channel has been selected yet
        }
    }
    
    func showChannelMenu() {
        // Create and show menu
        menu = menuManager.createMenu()
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        
        // Clear menu after it's dismissed
        DispatchQueue.main.async { [weak self] in
            self?.statusItem.menu = nil
        }
    }
    
    func updateStatusIcon(isPlaying: Bool) {
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: isPlaying ? "pause.circle" : "play.circle", 
                                 accessibilityDescription: isPlaying ? "Pause" : "Play")
        }
    }
}