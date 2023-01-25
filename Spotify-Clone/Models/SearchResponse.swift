//
//  SearchResponse.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 22/01/23.
//

import Foundation

struct SearchResponse: Decodable{
    let albums: AlbumsResponse
    let playlists: PlaylistResponse
    let tracks: TracksResponse
    let artists: ArtistsResponse
}

struct ArtistsResponse: Decodable{
    let items: [Artist]
}
