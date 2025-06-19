//
//  AuthManager.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 06.01.2025.
//

import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    
    private var  refreshingToken = false
    private var onRefreshBlocks = [((String) -> Void)]()
    
    struct Constants {
        static let clientID = "YOUR_CLIENT_ID"
        static let clientSecret = "YOUR_CLIENT_SECRET"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectUri = "https://steamcommunity.com/"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private init() {}
    
    public var sighInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectUri)"
        
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    // MARK: - Private methods
    
    private var accessToken: String? {
        UserDefaults.standard.string(forKey: "accessToken")
    }
    
    private var refreshToken: String? {
        UserDefaults.standard.string(forKey: "refreshToken")
    }
    
    private var tokenExperationDate: Date? {
        UserDefaults.standard.object(forKey: "experation") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let experationDate = tokenExperationDate else {
            return false
        }
        
        let currentDate = Date()
        let fiveMinutes = TimeInterval(300)
        return currentDate.addingTimeInterval(fiveMinutes) >= experationDate
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.accessToken, forKey: "accessToken")
        if let refreshToken = result.refreshToken {
            UserDefaults.standard.setValue(refreshToken, forKey: "refreshToken")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expiresIn)),
                                       forKey: "experation")

    }
    
    // MARK: - Public methods
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "grand_type", 
                                              value: "authorization_code"),
                                 URLQueryItem(name: "code",
                                              value: code),
                                 URLQueryItem(name: "redirect_uri",
                                              value: Constants.redirectUri)]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", 
                         forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failed to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")

        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return completion(false)
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                
                self?.cacheToken(result: result)
                completion(true)
            }
            catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    
    /// Supplies valid token to be used with API calls
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken {
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    public func refreshIfNeeded(completion:  ((Bool) -> Void)?) {
        guard !refreshingToken else {
            return
        }
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }

        refreshingToken = true
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "grand_type",
                                              value: "refresh_token"),
                                 URLQueryItem(name: "refresh_token    ",
                                              value: refreshToken)]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failed to get base64")
            completion?(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")

        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data, 
                    error == nil else {
                 completion?(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach({ $0(result.accessToken) })
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion?(true)
            }
            catch {
                print(error.localizedDescription)
                completion?(false)
            }
        }
        task.resume()
        
    }
}
