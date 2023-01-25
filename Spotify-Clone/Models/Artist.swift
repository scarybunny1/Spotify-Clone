//
//  Artist.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 23/12/22.
//

import Foundation

struct Artist: Codable{
    var id: String
    var name: String
    var external_urls: [String: String]
    var type: String
    var images: [APIImage]?
}
