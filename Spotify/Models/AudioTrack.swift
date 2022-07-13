//
//  AudioTrack.swift
//  Spotify
//
//  Created by Pranav Nithesh J on 06/05/21.
//

import Foundation

struct AudioTrack: Codable  {
    var album: Album?
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String: String]
    let name: String
    let id: String
    let preview_url: String?
    let uri: String?
}
