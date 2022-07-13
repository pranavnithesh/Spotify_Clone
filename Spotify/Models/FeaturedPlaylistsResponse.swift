//
//  FeaturedPlaylistsResponse.swift
//  Spotify
//
//  Created by Pranav Nithesh J on 15/05/21.
//

import Foundation


struct FeaturedPlaylistsResponse: Codable {
    let playlists: PlaylistsResponse
}

struct CategoryPlaylistsResponse: Codable {
    let playlists: PlaylistsResponse
}

struct PlaylistsResponse: Codable {
    let items: [Playlist]
} 

struct User: Codable {
    let id: String
    let display_name: String
    let external_urls: [String: String]
}
