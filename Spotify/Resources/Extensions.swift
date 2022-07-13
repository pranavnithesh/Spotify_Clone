//
//  Extensions.swift
//  Spotify
//
//  Created by Pranav Nithesh J on 09/05/21.
//

import Foundation
import UIKit
import AVFoundation

extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat {
        return frame.size.height
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
    
    var top: CGFloat {
        return frame.origin.y
    }
    
    var bottom: CGFloat {
        return top + height
    }
}

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }()
    
    static let displayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
}

extension String {
    static func formattedDate(string: String) -> String {
        guard let date = DateFormatter.dateFormatter.date(from: string) else {
            return string
        }
        return DateFormatter.displayDateFormatter.string(from: date)
    }
}

extension Notification.Name {
    static let albumSavedNotification = Notification.Name("albumSavedNotification")
}

extension AVQueuePlayer {
    func advanceToPreviousItem(for currentItem: Int, with initialItems: [AVPlayerItem], completion: (Bool) -> Void) {
    if currentItem < initialItems.count, currentItem >= 0 {
        self.removeAllItems()
        for i in currentItem..<initialItems.count {
            let obj: AVPlayerItem? = initialItems[i]
            if self.canInsert(obj!, after: nil) {
                obj?.seek(to: CMTime.zero, completionHandler: nil)
                self.insert(obj!, after: nil)
            }
        }
        completion(true)
        return
    }
    completion(false)
    return
 }
}

