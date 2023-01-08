//
//  AlbumDetailsResponse.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 09/01/23.
//

import Foundation

struct AlbumDetailsResponse: Decodable{
    
    let album_type: String
    let artists: [Artist]
    let external_urls: [String: String]
    let genres: [String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let tracks: TracksResponse
}

struct TracksResponse: Decodable{
    let items: [Track]
}
