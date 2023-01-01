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

//{
//    "access_token" = "BQDnaaGVSyA4CYumJKuiE7JkT6YkqMfIHg3-wNqTk57s1zt8kZEfr6JmlJGHGxyhqKhvKUT_8aWD-pCYZJNC2oOhNT_ZvQwKQ2RUjvDBP6fNKxw-v5kHh8QfHZ2PtudYRLODQWv0II4XhGD-3wN-8iWJmmxk2A12-dH8CIv0B1aJgT8DNFayh04pDNMeXsYkQjfc0kXEOBt3B9A";
//    "expires_in" = 3600;
//    "refresh_token" = "AQCI9Dd7eWvXBPId6UKCNaq55AEuhxuIa7sCQMqrhLesYkvn_yawtkuUuXEjE_l3MbWE7fzTaIw_2UMhn2nZS1mO5LXJnAH1S1xyZHm_iAq3VRW_mG797wOjawSwbIk-5z4";
//    scope = "user-read-private";
//    "token_type" = Bearer;
//}
