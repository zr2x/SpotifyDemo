//
//  AllCategoriesResponse.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 27.06.2025.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let id: Int
    let name: String
    let icons: [APIImage]
}
