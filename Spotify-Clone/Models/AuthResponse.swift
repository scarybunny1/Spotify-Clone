//
//  AuthResponse.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 31/12/22.
//

import Foundation

struct AuthResponse: Codable{
    var access_token: String
    var expires_in: Int
    var refresh_token: String?
    var scope: String
    var token_type: String
}
