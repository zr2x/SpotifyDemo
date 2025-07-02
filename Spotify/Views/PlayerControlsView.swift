//
//  PlayerControlsView.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 01.07.2025.
//

import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func didTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
    func didTapBackButton(_ playerControlsView: PlayerControlsView)
    func didTapForwardButton(_ playerControlsView: PlayerControlsView)
    func didVolumeChanged(_ playerControlsView: PlayerControlsView, value: Float)
}

struct PlayerControlsViewViewModel {
    let title: String
    let subtitle: String
}

final class PlayerControlsView: UIView {
    weak var delegate: PlayerControlsViewDelegate?
    
    var isPlaying: Bool = true
    
    private lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        slider.addTarget(self, action: #selector(didVolumeChanged), for: .valueChanged)
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return button
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: 50
        )
        
        subtitleLabel.frame = CGRect(
            x: 0,
            y: nameLabel.bottom + 10,
            width: width,
            height: 50
        )
        
        volumeSlider.frame = CGRect(
            x: 10,
            y: subtitleLabel.bottom + 20,
            width: width - 20,
            height: 44
        )
        
        let buttonSize: CGFloat = 60
        
        playPauseButton.frame = CGRect(
            x: (width - buttonSize) / 2,
            y: volumeSlider.bottom + 30,
            width: buttonSize,
            height: buttonSize
        )
        
        backButton.frame = CGRect(
            x: playPauseButton.left - 80 - buttonSize,
            y: playPauseButton.top,
            width: buttonSize,
            height: buttonSize
        )
        
        forwardButton.frame = CGRect(
            x: playPauseButton.right + 80,
            y: playPauseButton.top,
            width: buttonSize,
            height: buttonSize
        )
    }
    
    private func setupViews() {
        for subview in [volumeSlider, nameLabel, subtitleLabel, playPauseButton, backButton, forwardButton] {
            addSubview(subview)
        }
        clipsToBounds = true
    }
    
    public func configure(with viewModel: PlayerControlsViewViewModel) {
        self.nameLabel.text = viewModel.title
        self.subtitleLabel.text = viewModel.subtitle
    }
    
    // MARK - Actions
    @objc
    private func didTapPlayPause() {
        isPlaying.toggle()
        delegate?.didTapPlayPauseButton(self)
        
        let image = UIImage(
            systemName: isPlaying ? "pause" : "play.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 34,
                weight: .regular
            )
        )
        playPauseButton.setImage(image, for: .normal)
    }
    
    @objc
    private func didTapBack() {
        delegate?.didTapBackButton(self)

    }
    
    @objc
    private func didTapForward() {
        delegate?.didTapForwardButton(self)
    }
    
    @objc
    private func didVolumeChanged() {
        delegate?.didVolumeChanged(self, value: volumeSlider.value)
    }
}
