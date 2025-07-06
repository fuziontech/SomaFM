//
//  MenuManager.swift
//  SomaFM miniplayer
//
//  Created by James Greenhill on 7/5/25.
//

import AppKit
import Combine

class MenuManager: ObservableObject {
    static let shared = MenuManager()
    
    private let channelManager = ChannelManager()
    private let audioPlayer = AudioPlayer.shared
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setupBindings()
    }
    
    private func setupBindings() {
        // Update menu when channels change
        channelManager.$channels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateMenu()
            }
            .store(in: &cancellables)
        
        // Update menu when playing state changes
        audioPlayer.$isPlaying
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateMenu()
            }
            .store(in: &cancellables)
        
        audioPlayer.$currentChannel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateMenu()
            }
            .store(in: &cancellables)
    }
    
    func createMenu() -> NSMenu {
        let menu = NSMenu()
        
        if channelManager.channels.isEmpty {
            // Show loading or fetch channels
            let loadingItem = NSMenuItem(title: "Loading channels...", action: nil, keyEquivalent: "")
            loadingItem.isEnabled = false
            menu.addItem(loadingItem)
            
            // Fetch channels if not already loading
            if !channelManager.isLoading {
                channelManager.fetchChannels()
            }
        } else {
            // Add channels
            for channel in channelManager.channels {
                let item = NSMenuItem(
                    title: channel.title,
                    action: #selector(channelSelected(_:)),
                    keyEquivalent: ""
                )
                item.target = self
                item.representedObject = channel
                
                // Add checkmark for current channel
                if audioPlayer.currentChannel?.id == channel.id {
                    item.state = .on
                }
                
                // Add listener count as subtitle
                if let listeners = channel.listeners, listeners > 0 {
                    item.toolTip = "\(channel.description) (\(listeners) listeners)"
                } else {
                    item.toolTip = channel.description
                }
                
                menu.addItem(item)
            }
            
            menu.addItem(NSMenuItem.separator())
            
            // Add control items
            if audioPlayer.isPlaying {
                let pauseItem = NSMenuItem(
                    title: "Pause",
                    action: #selector(togglePlayPause),
                    keyEquivalent: ""
                )
                pauseItem.target = self
                menu.addItem(pauseItem)
            } else if audioPlayer.currentChannel != nil {
                let playItem = NSMenuItem(
                    title: "Play",
                    action: #selector(togglePlayPause),
                    keyEquivalent: ""
                )
                playItem.target = self
                menu.addItem(playItem)
            }
            
            menu.addItem(NSMenuItem.separator())
        }
        
        // Add quit item
        let quitItem = NSMenuItem(
            title: "Quit SomaFM",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )
        menu.addItem(quitItem)
        
        return menu
    }
    
    @objc private func channelSelected(_ sender: NSMenuItem) {
        guard let channel = sender.representedObject as? Channel else { return }
        audioPlayer.play(channel: channel)
    }
    
    @objc private func togglePlayPause() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else if audioPlayer.currentChannel != nil {
            audioPlayer.resume()
        }
    }
    
    private func updateMenu() {
        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            appDelegate.menu = createMenu()
        }
    }
}