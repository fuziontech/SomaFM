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
    @Published var currentSong: String?
    private var lastChannel: Channel?
    
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var cancellables = Set<AnyCancellable>()
    private var songTimer: Timer?
    
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
                    self?.lastChannel = channel
                    self?.updateAppDelegate()
                    self?.startFetchingSongInfo()
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
        currentSong = nil
        // Don't clear currentChannel when stopping
        cancellables.removeAll()
        songTimer?.invalidate()
        songTimer = nil
        updateAppDelegate()
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
        songTimer?.invalidate()
        updateAppDelegate()
    }
    
    func resume() {
        player?.play()
        isPlaying = true
        startFetchingSongInfo()
        updateAppDelegate()
    }
    
    private func updateAppDelegate() {
        DispatchQueue.main.async {
            if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
                appDelegate.updateStatusIcon(isPlaying: self.isPlaying)
            }
        }
    }
    
    private func startFetchingSongInfo() {
        songTimer?.invalidate()
        
        // Fetch immediately
        fetchCurrentSong()
        
        // Then fetch every 30 seconds
        songTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            self?.fetchCurrentSong()
        }
    }
    
    private func fetchCurrentSong() {
        guard let channel = currentChannel else { return }
        
        let songURL = "https://api.somafm.com/songs/\(channel.id).json"
        guard let url = URL(string: songURL) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data,
                  error == nil,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let songs = json["songs"] as? [[String: Any]],
                  let currentSong = songs.first else {
                return
            }
            
            DispatchQueue.main.async {
                if let artist = currentSong["artist"] as? String,
                   let title = currentSong["title"] as? String {
                    self?.currentSong = "\(artist) - \(title)"
                } else if let title = currentSong["title"] as? String {
                    self?.currentSong = title
                }
            }
        }.resume()
    }
}