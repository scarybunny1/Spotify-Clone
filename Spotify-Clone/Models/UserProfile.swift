//
//  UserProfile.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 23/12/22.
//

import Foundation

struct UserProfile: Codable{
    var country: String
    var display_name: String
    var email: String
    var explicit_content: ExplicitContent
    var external_urls: ExternalUrls
    var followers: Followers
    var id: String
    var images: [APIImage]
    var product: String
}

struct ExplicitContent: Codable{
    var filter_enabled: Bool
    var filter_locked: Bool
}

struct ExternalUrls: Codable{
    var spotify: String
}

struct Followers: Codable{
    var href: String?
    var total: Int
}


