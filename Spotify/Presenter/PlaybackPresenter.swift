//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 01.07.2025.
//

import UIKit

final class PlaybackPresenter {
    
    static func startPlaybackTrack(from viewController: UIViewController, track: AudioTack) {
        let vc = PlayerViewController()
        vc.title = track.name
        viewController.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    static func startPlaybackTracks(from viewController: UIViewController, tracks: [AudioTack]) {
        let vc = PlayerViewController()
        viewController.present(UINavigationController(rootViewController: vc), animated: true)
    }
}
