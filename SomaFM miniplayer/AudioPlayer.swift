//
//  AudioPlayer.swift
//  SomaFM miniplayer
//
//  Created by James Greenhill on 7/5/25.
//

import Foundation
import AVFoundation
import Combine
import AppKit

class AudioPlayer: NSObject, ObservableObject {
    static let shared = AudioPlayer()
    
    @Published var isPlaying = false
    @Published var currentChannel: Channel?
    
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var cancellables = Set<AnyCancellable>()
    
    private override init() {
        super.init()
    }
    
    func play(channel: Channel) {
        stop()
        
        guard let url = URL(string: channel.streamURL) else {
            print("Invalid stream URL")
            return
        }
        
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        // Observe player status
        playerItem?.publisher(for: \.status)
            .sink { [weak self] status in
                if status == .readyToPlay {
                    self?.player?.play()
                    self?.isPlaying = true
                    self?.currentChannel = channel
                    self?.updateAppDelegate()
                } else if status == .failed {
                    print("Failed to load stream")
                    self?.isPlaying = false
                    self?.updateAppDelegate()
                }
            }
            .store(in: &cancellables)
        
        // Handle playback interruptions
        NotificationCenter.default.publisher(for: AVPlayerItem.playbackStalledNotification)
            .sink { [weak self] _ in
                self?.player?.play()
            }
            .store(in: &cancellables)
    }
    
    func stop() {
        player?.pause()
        player = nil
        playerItem = nil
        isPlaying = false
        currentChannel = nil
        cancellables.removeAll()
        updateAppDelegate()
    }
    
    private func updateAppDelegate() {
        DispatchQueue.main.async {
            if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
                appDelegate.updateStatusIcon(isPlaying: self.isPlaying)
            }
        }
    }
}