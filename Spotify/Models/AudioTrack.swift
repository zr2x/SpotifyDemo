//
//  AudioTrack.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 06.01.2025.
//

import Foundation

struct AudioTack: Codable {
    let album: Album?
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let explicit: Bool
    let external_urls: [String: String]
    let id: String
    let name: String
}
