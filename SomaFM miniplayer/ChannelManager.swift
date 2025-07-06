//
//  ChannelManager.swift
//  SomaFM miniplayer
//
//  Created by James Greenhill on 7/5/25.
//

import Foundation
import Combine

class ChannelManager: ObservableObject {
    @Published var channels: [Channel] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let channelsURL = "https://api.somafm.com/channels.json"
    
    func fetchChannels() {
        isLoading = true
        error = nil
        
        guard let url = URL(string: channelsURL) else {
            error = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: SomaFMResponse.self, decoder: JSONDecoder())
            .map { response in
                response.channels.map { channelData in
                    Channel(from: channelData)
                }
                .filter { !$0.streamURL.isEmpty }
                .sorted { ($0.listeners ?? 0) > ($1.listeners ?? 0) }
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.error = error.localizedDescription
                        // Load cached channels if available
                        self?.loadCachedChannels()
                    }
                },
                receiveValue: { [weak self] channels in
                    self?.channels = channels
                    self?.cacheChannels(channels)
                }
            )
            .store(in: &cancellables)
    }
    
    private func cacheChannels(_ channels: [Channel]) {
        if let encoded = try? JSONEncoder().encode(channels) {
            UserDefaults.standard.set(encoded, forKey: "cachedChannels")
        }
    }
    
    private func loadCachedChannels() {
        if let data = UserDefaults.standard.data(forKey: "cachedChannels"),
           let channels = try? JSONDecoder().decode([Channel].self, from: data) {
            self.channels = channels
        }
    }
}