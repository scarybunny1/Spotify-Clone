//
//  RecommendationsResponse.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 06/01/23.
//

import Foundation

struct RecommendationsResponse: Decodable{
    let tracks: [Track]
}

struct Track: Codable{
    var id: String
    var name: String
    var disc_number: Int
    var album: Album?
    var artists: [Artist]
    var available_markets: [String]
    var duration_ms: Int
    var external_urls: [String: String]
    var preview_url: String?
}
