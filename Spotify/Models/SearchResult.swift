//
//  SearchResult.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 30.06.2025.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTack)
    case playlists(model: Playlist)
}
