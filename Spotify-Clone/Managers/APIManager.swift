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
        case DELETE = "DELETE"
        case PUT = "PUT"
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
    
    //MARK:  Profile
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
    
    //MARK:  New Releases
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
    
    //MARK:  Featured Playlists
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
    
    //MARK:  Recommended Tracks
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
    
    //MARK:  Recommended Genres
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
    
    //MARK:  Get Album
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseUrl + "/albums/\(album.id)"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let json = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(json))
                }
                catch{
                    print("Failed to serialize data \(error)")
                }
            }.resume()
        }
    }
    
    public func getCurrentUserAlbums(completion: @escaping (Result<[Album], Error>) -> Void) {
        guard let url = URL(string: Constants.baseUrl + "/me/albums") else{
            return
        }
        createRequest(with: url, type: .GET) { request in
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let json = try JSONDecoder().decode(LibraryAlbumResponse.self, from: data)
                    completion(.success(json.items.compactMap({ savedAlbum in
                        return savedAlbum.album
                    })))
                }
                catch{
                    print("Failed to serialize json data: \(error)")
                }
            }
            
            dataTask.resume()
        }
    }
    
    public func saveAlbum(_ album: Album, completion: @escaping (Bool) -> Void){
        createRequest(with: URL(string: Constants.baseUrl + "/me/albums"), type: .PUT) { baseRequest in
            var request = baseRequest
            let json = ["ids": [album.id]]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let code = (response as? HTTPURLResponse)?.statusCode, error == nil else{
                    completion(false)
                    return
                }
                completion(code == 200)
            }
            dataTask.resume()
        }
    }
    
    //MARK:  Get Playlist
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseUrl + "/playlists/\(playlist.id)"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let json = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completion(.success(json))
                }
                catch{
                    print("Failed to serialize json data: \(error)")
                }
            }.resume()
        }
    }
    
    //MARK:  Playlists methods
    
    public func getCurrentUserPlaylists(completion: @escaping (Result<[Playlist], Error>) -> Void){
        guard let url = URL(string: Constants.baseUrl + "/me/playlists") else{
            return
        }
        createRequest(with: url, type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let json = try JSONDecoder().decode(LibraryPlaylistResponse.self, from: data)
                    completion(.success(json.items))
                }
                catch{
                    print("Failed to serialize json data")
                }
            }.resume()
        }
    }
    
    public func addTrackToPlaylist(track: Track, playlist: Playlist, completion: @escaping (Bool) -> Void){
        guard let url = URL(string: Constants.baseUrl + "/playlists/\(playlist.id)/tracks") else{
            return
        }
        createRequest(with: url, type: .POST) { baseRequest in
            var request = baseRequest
            let json = ["uris": ["spotify:track:\(track.id)"]]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    completion(false)
                    return
                }
                do{
                    let json = try JSONSerialization.jsonObject(with: data)
                    print(json)
                    if let response = json as? [String: Any], response["snapshot_id"] as? String != nil{
                        completion(true)
                    }
                    else{
                        completion(false)
                    }
                }
                catch{
                    print("Failed to serialize json data")
                }
            }.resume()
        }
    }
    
    public func removeTrackFromPlaylist(track: Track, playlist: Playlist, completion: @escaping (Bool) -> Void){
        guard let url = URL(string: Constants.baseUrl + "/playlists/\(playlist.id)/tracks") else{
            return
        }
        createRequest(with: url, type: .DELETE) { baseRequest in
            var request = baseRequest
            let json: [String: Any] = [
                "tracks": [
                    [
                        "uri": "spotify:track:\(track.id)"
                    ]
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    completion(false)
                    return
                }
                do{
                    let json = try JSONSerialization.jsonObject(with: data)
                    print(json)
                    if let response = json as? [String: Any], response["snapshot_id"] as? String != nil{
                        completion(true)
                    }
                    else{
                        completion(false)
                    }
                }
                catch{
                    print("Failed to serialize json data")
                }
            }.resume()
        }
    }
    
    public func createPlaylist(with name: String, completion: @escaping (Bool) -> Void){
        
        getCurrentUserProfile { [weak self] result in
            switch result {
            case .success(let profile):
                let url = URL(string: Constants.baseUrl + "/users/\(profile.id)/playlists")
                self?.createRequest(with: url, type: .POST) { baseRequest in
                    var request = baseRequest
                    let json = ["name": name]
                    print(json)
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data, error == nil else{
                            completion(false)
                            return
                        }
                        do{
                            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            if let response = json as? [String: Any], response["id"] as? String != nil{
                                completion(true)
                            }
                            else{
                                completion(false)
                            }
                        }
                        catch{
                            print(error)
                        }
                    }.resume()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK:  Get Categories
    
    public func getCategories(completion: @escaping (Result<GetCategoriesResponse, Error>) -> Void){
        let limit = 50
        createRequest(with: URL(string: Constants.baseUrl + "/browse/categories?limit=\(limit)"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let json = try JSONDecoder().decode(GetCategoriesResponse.self, from: data)
                    completion(.success(json))
                }
                catch{
                    print("Failed to serialize json data: \(error)")
                }
            }.resume()
        }
    }
    
    //MARK:  Get Categories Playlist
    
    public func getCategoriesPlaylist(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void){
        createRequest(with: URL(string: Constants.baseUrl + "/browse/categories/\(category.id)/playlists"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let json = try JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
                    completion(.success(json.playlists.items))
                    print(json)
                }
                catch{
                    print("Failed to serialize json data: \(error)")
                }
            }.resume()
        }
    }
    
    //MARK:  Search
    
    public func search(query: String, completion: @escaping (Result<[[SearchResults]], Error>) -> Void){
        let urlString = Constants.baseUrl + "/search?" + "q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" + "&type=album,artist,playlist,track"
        let url = URL(string: urlString)
        createRequest(with: url, type: .GET) {request in
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let json = try JSONDecoder().decode(SearchResponse.self, from: data)
                    var searchResults: [[SearchResults]] = [[],[],[],[]]
                    searchResults[0].append(contentsOf: json.tracks.items.compactMap({SearchResults.tracks(model: $0)}))
                    searchResults[1].append(contentsOf: json.albums.items.compactMap({SearchResults.albums(model: $0)}))
                    searchResults[2].append(contentsOf: json.artists.items.compactMap({SearchResults.artists(model: $0)}))
                    searchResults[3].append(contentsOf: json.playlists.items.compactMap({SearchResults.playlists(model: $0)}))
                    completion(.success(searchResults))
                }
                catch{
                    print("Failed to serialize json data: \(error)")
                }
            }).resume()
        }
    }
    
    //MARK:  Private functions
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void){
        
        AuthManager.shared.withValidToken { token in
            guard let apiUrl = url else{
                return
            }
            var request = URLRequest(url: apiUrl)
            request.httpMethod = type.rawValue
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            completion(request)
        }
    }
}
