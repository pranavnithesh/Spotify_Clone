//
//  LibraryAlbumsResponse.swift
//  Spotify
//
//  Created by Pranav Nithesh J on 23/05/21.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album 
}
