//
//  PlaylistHeaderViewModel.swift
//  Spotify
//
//  Created by Pranav Nithesh J on 16/05/21.
//

import Foundation

struct PlaylistHeaderViewModel: Codable {
    let name: String?
    let ownerName: String?
    let description: String?
    let artworkURL: URL?
}
