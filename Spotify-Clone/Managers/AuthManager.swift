//
//  AuthManager.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 23/12/22.
//

import Foundation

final class AuthManager{
    struct Constants{
        static let clientID = "c2caa7acbf8b493f845a02080bc7f50d"
        static let clientSecret = "7a7f0dae7f5a4fdd9ae7313cee1f342a"
        
        static let baseURL = "https://accounts.spotify.com"
        static let redirectURI = "https://github.com/scarybunny1/Spotify-Clone"
        static let accessTokenUrl = "\(baseURL)/api/token"
        static let refreshTokenUrl = "\(baseURL)/api/refresh_token"
        static let scope = "user-read-private%20playlist-read-private%20playlist-read-collaborative%20playlist-modify-private%20playlist-modify-public%20user-follow-modify%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email%20user-read-private"
    }
    
    struct UserDefaultKeys{
        static let ACCESS_TOKEN = "ACCESS_TOKEN"
        static let REFRESH_TOKEN = "REFRESH_TOKEN"
        static let EXPIRATION_DATE = "EXPIRATION_DATE"
        
    }
    
    static let shared = AuthManager()
    
    public var signInURL: URL? {
        let urlString = "\(Constants.baseURL)/authorize?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scope)&redirect_uri=\(Constants.redirectURI)"
        return URL(string: urlString)
    }
    
    var isSignedIn: Bool{
        return accessToken != nil
    }
    
    private var accessToken: String?{
        return UserDefaults.standard.string(forKey: UserDefaultKeys.ACCESS_TOKEN)
    }
    
    private var refreshToken: String?{
        return UserDefaults.standard.string(forKey: UserDefaultKeys.REFRESH_TOKEN)
    }
    
    private var tokenExpirationDate: Date?{
        return UserDefaults.standard.object(forKey: UserDefaultKeys.EXPIRATION_DATE) as? Date
    }
    
    private var shouldRefreshToken: Bool{
        if let tokenExpirationDate = tokenExpirationDate{
            return Date().addingTimeInterval(TimeInterval(300)) >= tokenExpirationDate
        }
        return false
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)){
        guard let url = URL(string: Constants.accessTokenUrl) else{
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            
        ]
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let base64EncodedToken = Data(basicToken.utf8).base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64EncodedToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            do{
                let json = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("SUCCESS: \(json)")
                self.cacheToken(json)
                completion(true)
            }
            catch{
                print("Failed to exchange access token")
                completion(false)
            }
        }.resume()
    }
    
    public func refreshIfNeeded(completion: @escaping (Bool) -> Void){
        guard shouldRefreshToken else{
            completion(true)
            return
        }
        
        guard let url = URL(string: Constants.refreshTokenUrl) else{
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: UserDefaults.standard.string(forKey: UserDefaultKeys.REFRESH_TOKEN)),
        ]
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let base64EncodedToken = Data(basicToken.utf8).base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64EncodedToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            do{
                let json = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("SUCCESS: \(json)")
                self.cacheToken(json)
                completion(true)
            }
            catch{
                print("Failed to exchange access token")
                completion(false)
            }
        }.resume()
    }
    
    public func cacheToken(_ result: AuthResponse){
        UserDefaults.standard.set(result.access_token, forKey: "ACCESS_TOKEN")
        if let refresh_token = result.refresh_token{
            UserDefaults.standard.set(refresh_token, forKey: "REFRESH_TOKEN")
        }
        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "EXPIRATION_DATE")
        
    }
}
