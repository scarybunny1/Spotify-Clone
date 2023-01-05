//
//  SettingsModel.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 01/01/23.
//

import Foundation

struct Section{
    let title: String
    let option: [Option]
}

struct Option{
    let title: String
    let handler: () -> Void
}
