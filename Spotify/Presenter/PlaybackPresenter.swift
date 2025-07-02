//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 01.07.2025.
//

import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
    
}

final class PlaybackPresenter {
    static let shared = PlaybackPresenter()
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    private var playerVC: PlayerViewController?
    var index = 0
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if let player = self.playerQueue, tracks.isNotEmpty {
            let item = player.currentItem
            return tracks[index]
        }
            
        return nil
    }
    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?

    private init() { }
    
    func startPlaybackTrack(from viewController: UIViewController, track: AudioTrack) {
        guard let urlString = track.preview_url,
              let url = URL(string: urlString) else {
            return }
        
        player = AVPlayer(url: url)
        player?.volume = 0.5
        
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        
        self.track = track
        self.tracks = []
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?   .player?.play()
        }
        self.playerVC = vc
    }
    
    func startPlaybackTracks(from viewController: UIViewController, tracks: [AudioTrack]) {
        let vc = PlayerViewController()
        vc.title = currentTrack?.name ?? ""
        vc.dataSource = self
        vc.delegate = self
        
        self.tracks = tracks
        self.track = nil
        let items: [AVPlayerItem] = tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else { return nil
            }
            return AVPlayerItem(url: url)
        })
        playerQueue = AVQueuePlayer(items: items)
        playerQueue?.play()
        
        viewController.present(UINavigationController(rootViewController: vc), animated: true)
        self.playerVC = vc
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
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}

// MARK: - PlayerViewControllerDelegate
extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didTapPlayPause() {
        if let player = player,
           player.timeControlStatus == .playing {
            player.pause()
        } else if player?.timeControlStatus == .paused {
            player?.play()
        } else if let playerQueue = playerQueue {
            if playerQueue.timeControlStatus == .playing {
                playerQueue.pause()
            } else {
                playerQueue.play()
            }
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            player?.pause()
            player?.play()
        } else if let firstItem = playerQueue?.items() {
            self.index -= 1
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: firstItem)
            player?.play()
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            player?.pause()
        } else if let playerQueue = playerQueue {
            self.index += 1
            playerQueue.advanceToNextItem()
            playerVC?.refreshUI()
        }
    }
    
    func didVolumeChanged(value: Float) {
        player?.volume = value
    }
}
