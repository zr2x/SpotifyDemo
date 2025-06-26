//
//  FeaturedPlaylistCollectionViewCell.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 20.06.2025.
//

import UIKit

final class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    private var playlistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private var playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private var creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.clipsToBounds = true
        
        for view in [playlistImageView, playlistNameLabel, creatorNameLabel] {
            contentView.addSubview(view)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
     
        creatorNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height - 30,
            width: contentView.width - 6,
            height: 30
        )
        
        playlistNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height - 60,
            width: contentView.width - 6,
            height: 30
        )
        
        let imageSize = contentView.height - 70
        
        playlistImageView.frame = CGRect(
            x: (contentView.width - imageSize)/2,
            y: 3,
            width: imageSize,
            height: imageSize
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistImageView.image = nil
    }
    
    public func configure(with viewModel: FeaturedPlaylistCellViewModel) {
        playlistNameLabel.text = viewModel.playlistName
        creatorNameLabel.text = viewModel.creatorName
        playlistImageView.sd_setImage(with: viewModel.imageURL)
    }
}
