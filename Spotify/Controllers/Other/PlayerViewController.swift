//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 06.01.2025.
//

import UIKit

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapBackward()
    func didTapForward()
    func didVolumeChanged(value: Float)
}

class PlayerViewController: UIViewController {
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
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
        configure()
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
    
    public func refreshUI() {
        configure()
    }
    
    public func configure() {
        imageView.sd_setImage(with: dataSource?.imageURL)
        let viewModel = PlayerControlsViewViewModel(
            title: dataSource?.songName ?? "",
            subtitle: dataSource?.subtitle ?? ""
        )
        
        controlsView.configure(with: viewModel)
    }
    
    @objc
    private func didTapClose() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapAction() {
        //TODO: setup action
        dismiss(animated: true)
    }
}

// MARK: - PlayerControlsViewDelegate
extension PlayerViewController: PlayerControlsViewDelegate {
    func didVolumeChanged(_ playerControlsView: PlayerControlsView, value: Float) {
        delegate?.didVolumeChanged(value: value)
    }
    
    func didTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPause()
    }
    
    func didTapBackButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapBackward()
    }
    
    func didTapForwardButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapForward()
    }
}
