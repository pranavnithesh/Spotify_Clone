//
//  HapticsManager.swift
//  Spotify
//
//  Created by Pranav Nithesh J on 06/05/21.
//

import Foundation
import UIKit

final class HapticManager {
    static let shared = HapticManager()
    
    private init() { }
    
    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
