//
//  Artist.swift
//  Spotify
//
//  Created by Pranav Nithesh J on 06/05/21.
//

import Foundation

struct Artist: Codable {
    let id: String
    let type : String
    let name: String
    let images: [APIImage]?
    let external_urls: [String: String]
} 
