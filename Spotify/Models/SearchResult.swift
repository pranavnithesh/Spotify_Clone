//
//  SearchResult.swift
//  Spotify
//
//  Created by Pranav Nithesh J on 20/05/21.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
