//
//  ChannelListView.swift
//  SomaFM miniplayer
//
//  Created by James Greenhill on 7/5/25.
//

import SwiftUI

struct ChannelListView: View {
    @StateObject private var channelManager = ChannelManager()
    @StateObject private var audioPlayer = AudioPlayer.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "radio")
                    .font(.title2)
                Text("SomaFM")
                    .font(.headline)
                Spacer()
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Image(systemName: "xmark.circle")
                        .font(.caption)
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Channel list
            ScrollView {
                VStack(spacing: 1) {
                    ForEach(channelManager.channels) { channel in
                        ChannelRowView(channel: channel)
                    }
                }
            }
            .background(Color(NSColor.windowBackgroundColor))
            
            if channelManager.isLoading {
                ProgressView("Loading channels...")
                    .padding()
            }
            
            if let error = channelManager.error {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .frame(width: 300, height: 400)
        .onAppear {
            channelManager.fetchChannels()
        }
    }
}

struct ChannelRowView: View {
    let channel: Channel
    @StateObject private var audioPlayer = AudioPlayer.shared
    
    private var isPlaying: Bool {
        audioPlayer.currentChannel?.id == channel.id && audioPlayer.isPlaying
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(channel.title)
                    .font(.system(size: 13, weight: .medium))
                    .lineLimit(1)
                Text(channel.description)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            if isPlaying {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.caption)
                    .foregroundColor(.accentColor)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isPlaying ? Color.accentColor.opacity(0.1) : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            if isPlaying {
                audioPlayer.stop()
            } else {
                audioPlayer.play(channel: channel)
            }
        }
    }
}