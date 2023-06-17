//
//  LibraryAlbumResponse.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 22/02/23.
//

import Foundation

struct LibraryAlbumResponse: Decodable{
    var items: [SavedAlbum]
}

struct SavedAlbum: Decodable{
    var album: Album
}
