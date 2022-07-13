//
//  Playlist.swift
//  Spotify
//
//  Created by Pranav Nithesh J on 06/05/21.
//

import Foundation


struct Playlist: Codable {
    let description: String
    let id: String
    let name: String
    let external_urls: [String: String]
    let images: [APIImage]
    let owner: User
} 
