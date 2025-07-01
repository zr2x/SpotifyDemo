//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 06.01.2025.
//

import UIKit

class PlayerViewController: UIViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let controlsView = PlayerControlsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureBarButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.width
        )
        
        controlsView.frame = CGRect(
            x: 10,
            y: imageView.bottom + 10,
            width: view.width - 20,
            height: view.height - imageView.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15
        )
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        view.addSubview(imageView)
        view.addSubview(controlsView)
        
        controlsView.delegate = self
    }
    
    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapAction)
        )
    }
    
    @objc
    private func didTapClose() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapAction() {
        dismiss(animated: true)
    }
}

    // MARK: - PlayerControlsViewDelegate
extension PlayerViewController: PlayerControlsViewDelegate {
    func didTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        
    }
    
    func didTapBackButton(_ playerControlsView: PlayerControlsView) {
        
    }
    
    func didTapForwardButton(_ playerControlsView: PlayerControlsView) {
        
    }
}
