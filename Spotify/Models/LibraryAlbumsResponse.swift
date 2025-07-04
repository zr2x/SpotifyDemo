//
//  LibraryAlbumsResponse.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 04.07.2025.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let album: Album
}
