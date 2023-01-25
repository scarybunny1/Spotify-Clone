//
//  SearchResults.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 22/01/23.
//

import Foundation

enum SearchResults{
    case albums(model: Album)
    case artists(model: Artist)
    case playlists(model: Playlist)
    case tracks(model: Track)
}
