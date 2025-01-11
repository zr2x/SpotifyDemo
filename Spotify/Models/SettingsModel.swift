//
//  SettingsModel.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 09.01.2025.
//

import Foundation

struct Section {
    let title: String
    let options: [Options]
    
}

struct Options {
    let title: String
    let handler: () -> Void
}
