//
//  APIManager.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 23/12/22.
//

import Foundation

final class APIManager{
    
    struct Constants{
        static let baseUrl = "https://api.spotify.com/v1"
    }
    
    enum HTTPMethod: String{
        case GET = "GET"
        case POST = "POST"
    }
    
    enum APIError: Error{
        case failedToGetData
    }
    
    static let shared = APIManager()
    struct ProfileError: Codable{
        struct EE: Codable{
            var status: Int
            var message: String
        }
        let error: EE
    }
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseUrl + "/me"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    
                    return
                }
                do{
                    let json = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(json))
                }
                catch{
                    print("Failed to get user profile\(error)")
                }
            }
            task.resume()
        }
    }
    
    //MARK:  Private functions
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void){
        
        AuthManager.shared.withValidToken { token in
            guard let apiUrl = url else{
                return
            }
            var request = URLRequest(url: apiUrl)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            completion(request)
        }
    }
}
