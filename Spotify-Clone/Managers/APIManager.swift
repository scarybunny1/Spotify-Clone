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
    
    public func getNewReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void){
        let country = "SE"
        let limit = 20
        let offset = 0
        let urlString = Constants.baseUrl + "/browse/new-releases?country=\(country)&limit=\(limit)&offset=\(offset)"
        createRequest(with: URL(string: urlString), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let json = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(json))
                }
                catch{
                    print("Failed to deserialize json data")
                }
            }
            task.resume()
        }
    }
    
    public func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void){
        let limit = 20
        let offset = 0
        let urlString = Constants.baseUrl + "/browse/featured-playlists?limit=\(limit)&offset=\(offset)"
        createRequest(with: URL(string: urlString), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let json = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(json))
                }
                catch{
                    print("Failed to deserialize json data")
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendations(genreSeed: [String], completion: @escaping (Result<RecommendationsResponse, Error>) -> Void){
        let genre_seed = genreSeed.joined(separator: ",")
        let urlString = Constants.baseUrl + "/recommendations?seed_genres=\(genre_seed)&limit=20"
        
        createRequest(with: URL(string: urlString), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let json = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(json))
                }
                catch{
                    print("Failed to deserialize json data: \(error)")
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendedGenres(completion: @escaping (Result<RecommendedGenreResponse, Error>) -> Void){
        let urlString = Constants.baseUrl + "/recommendations/available-genre-seeds"
        
        createRequest(with: URL(string: urlString), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let json = try JSONDecoder().decode(RecommendedGenreResponse.self, from: data)
                    completion(.success(json))
                }
                catch{
                    print("Failed to deserialize json data")
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
