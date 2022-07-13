//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Pranav Nithesh J on 21/05/21.
//

import Foundation
import AVFoundation
import UIKit

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

final class PlaybackPresenter {
    static let shared = PlaybackPresenter()
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    var index = 0
    var playerVC: PlayerViewController?
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if let _ = self.playerQueue, !tracks.isEmpty, index < tracks.count, index >= 0 {
            return tracks[index]
        }
        return nil
    }
    
    func startPlayback(from viewController: UIViewController, track: AudioTrack) {
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        self.player = AVPlayer(url: url)
        self.player?.volume =  0.5
        self.track = track
        self.tracks = []
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        self.playerVC = vc
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self]  in
            self?.player?.play()
        }
    }
    
    func startPlayback(from viewController: UIViewController, tracks: [AudioTrack]) {
        self.track = nil
        self.tracks = tracks
        let items: [AVPlayerItem] = tracks.compactMap( {
            guard let url = URL(string: $0.preview_url ?? "") else {
                return nil
            }
            return AVPlayerItem(url: url)
        })
        self.playerQueue = AVQueuePlayer(items: items)
        self.playerQueue?.volume = 0.5
        self.playerQueue?.play()
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        self.playerVC = vc
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    
    func didTapClose() {
        player?.pause()
        player = nil
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            //Not Playlist or Album
            player?.pause()
            player?.play()
        } else if let player = playerQueue {
            player.advanceToNextItem()
            index += 1
            playerVC?.refreshUI()
        }
    }
    func didTapBackward() {
        if tracks.isEmpty {
            //Not Playlist or Album
            player?.pause()
            player?.play()
        } else {
//
            guard let player = self.playerQueue else { return }
            player.advanceToPreviousItem(for: index, with: player.items()) { [weak self] success in
                if success {
                    self?.index -= 1
                    DispatchQueue.main.async {
                        self?.playerVC?.refreshUI()
                    }
                    self?.playerQueue?.play()
                }
            }
        }
    }
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        } else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "" )
    }
}
