//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 24.06.2025.
//

import SDWebImage
import UIKit

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func didTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private let playListImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let playAllButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(buttonImage, for: .normal)
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
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
        
        let imageSize: CGFloat = height / 1.5
        playListImageView.frame = CGRect(
            x: (width - imageSize) / 2,
            y: 20,
            width: imageSize,
            height: imageSize
        )
        
        playlistNameLabel.frame = CGRect(
            x: 10 ,
            y: playListImageView.bottom,
            width: width - 20,
            height: 44
        )
        
        descriptionLabel.frame = CGRect(
            x: 10,
            y: playlistNameLabel.bottom,
            width: width - 20,
            height: 44
        )
        
        ownerLabel.frame = CGRect(
            x: 10,
            y: descriptionLabel.bottom,
            width: width - 20,
            height: 44
        )
        
        playAllButton.frame = CGRect(
            x: width - 80,
            y: width - 80,
            width: 60,
            height: 60
        )
    }
    
    private func setupViews() {
        for view in [playlistNameLabel, descriptionLabel, ownerLabel, playListImageView, playAllButton] {
            addSubview(view)
        }
        
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    @objc
    private func didTapPlayAll() {
        delegate?.didTapPlayAll(self)
    }
    
    func configure(with viewModel: PlaylistHeaderViewViewModel) {
        playListImageView.sd_setImage(with: viewModel.playlistImageURL)
        playlistNameLabel.text = viewModel.playlistName
        ownerLabel.text = viewModel.ownerName
        descriptionLabel.text = viewModel.playlistDescription
    }
}
