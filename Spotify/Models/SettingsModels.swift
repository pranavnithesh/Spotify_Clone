//
//  SettingsModels.swift
//  Spotify
//
//  Created by Pranav Nithesh J on 12/05/21.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
