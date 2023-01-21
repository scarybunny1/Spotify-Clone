//
//  CategoriesResponse.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 20/01/23.
//

import Foundation

struct GetCategoriesResponse: Decodable{
    let categories: CategoriesResponse
}

struct CategoriesResponse: Decodable{
    let items: [Category]
}

struct Category: Codable{
    let icons: [APIImage]
    let name: String
    let id: String
}
