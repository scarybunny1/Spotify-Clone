//
//  NewReleasesResponse.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 06/01/23.
//

import Foundation

struct NewReleasesResponse: Decodable{
    var albums: AlbumsResponse
}

struct AlbumsResponse: Decodable{
    var items: [Album]
}

struct Album: Codable{
    var album_type: String
    var artists: [Artist]
    var external_urls: [String: String]
    var available_markets: [String]
    var id: String
    var images: [APIImage]
    var name: String
    var release_date: String
    var total_tracks: Int
}
