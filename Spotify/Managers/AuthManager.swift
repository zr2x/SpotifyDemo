//
//  AuthManager.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 06.01.2025.
//

import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    
    struct Constants {
        static let clientID = "YOUR_CLIENT_ID"
        static let clientSecret = "YOUR_CLIENT_SECRET"
    }
    
    private init() {}
    
    public var sighInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let scopes = "user-read-private"
        let redirectUri = "https://steamcommunity.com/"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectUri)"
        
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExperationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
    
    private func cacheToke() {
        
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        
    }
    
    public func refreshAccessToken() {
        
    }

}
