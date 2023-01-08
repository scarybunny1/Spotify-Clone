//
//  PlaylistDetailsResponse.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 09/01/23.
//

import Foundation

struct PlaylistDetailsResponse: Decodable{
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
    let tracks: PlaylistTrackResponse
}

struct PlaylistTrackResponse: Decodable{
    let items: [PlaylistItem]
}

struct PlaylistItem: Decodable{
    let track: Track
}
