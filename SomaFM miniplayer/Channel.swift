//
//  Channel.swift
//  SomaFM miniplayer
//
//  Created by James Greenhill on 7/5/25.
//

import Foundation

struct Channel: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let streamURL: String
    let imageURL: String?
    let genre: String?
    let listeners: Int?
    
    init(from channelData: ChannelData) {
        self.id = channelData.id
        self.title = channelData.title
        self.description = channelData.description
        // Get the highest quality MP3 stream
        self.streamURL = channelData.playlists
            .first(where: { $0.format == "mp3" && $0.quality == "highest" })?.url
            ?? channelData.playlists.first?.url ?? ""
        self.imageURL = channelData.xlimage ?? channelData.largeimage ?? channelData.image
        self.genre = channelData.genre
        self.listeners = Int(channelData.listeners ?? "0")
    }
}

// SomaFM API Response structures
struct SomaFMResponse: Codable {
    let channels: [ChannelData]
}

struct ChannelData: Codable {
    let id: String
    let title: String
    let description: String
    let image: String?
    let largeimage: String?
    let xlimage: String?
    let genre: String?
    let listeners: String?
    let playlists: [Playlist]
    let dj: String?
    let updated: String?
}

struct Playlist: Codable {
    let url: String
    let format: String
    let quality: String
}