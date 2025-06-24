//
//  PlaylistDetailResponse.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 23.06.2025.
//

import Foundation

struct PlaylistDetailResponse: Codable {
    let description: String
    let external_urls: String
    let id: String
    let images: [APIImage]
    let name: String
    let tracks: PlaylistTrackResponse
}

struct PlaylistTrackResponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let track: AudioTack
}
