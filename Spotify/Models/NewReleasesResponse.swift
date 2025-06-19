//
//  NewReleasesResponse.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 18.06.2025.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}

struct Album: Codable {
    let album_type: String
    let available_markets: String
    let id: String
    let images: [APIImage]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artist: [Artist]
}


