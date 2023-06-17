//
//  LibraryPlaylistResponse.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 05/02/23.
//

import Foundation

struct LibraryPlaylistResponse: Decodable{
    let items: [Playlist]
}
