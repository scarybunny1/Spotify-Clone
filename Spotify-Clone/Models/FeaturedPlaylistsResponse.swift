//
//  FeaturedPlaylistsResponse.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 06/01/23.
//

import Foundation

struct FeaturedPlaylistsResponse: Decodable{
    var playlists: PlaylistResponse
}

struct CategoryPlaylistsResponse: Decodable{
    var playlists: PlaylistResponse
}

struct PlaylistResponse: Decodable{
    var items: [Playlist]
}

struct Playlist: Decodable{
    var id: String
    var name: String
    var description: String
    var images: [APIImage]
    var owner: User
    var external_urls: [String: String]
}

struct User: Decodable{
    var display_name: String
    var external_urls: [String: String]
    var id: String
}
