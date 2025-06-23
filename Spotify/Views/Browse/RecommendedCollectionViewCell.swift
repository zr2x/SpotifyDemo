//
//  RecommendedCollectionViewCell.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 20.06.2025.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifire = "RecommendedTrackCollectionViewCell"

    private var trackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private var trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.clipsToBounds = true
        
        for view in [trackImageView, trackNameLabel, artistNameLabel] {
            contentView.addSubview(view)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        trackNameLabel.frame = CGRect(
            x: trackImageView.right + 10,
            y: 0,
            width: contentView.width - trackImageView.right - 15,
            height: contentView.height / 2
        )
        
        artistNameLabel.frame = CGRect(
            x: trackImageView.right + 10,
            y: contentView.height / 2,
            width: contentView.width - trackImageView.right - 15,
            height: contentView.height / 2
        )
                
        trackImageView.frame = CGRect(
            x: 5,
            y: 2,
            width: contentView.height - 4,
            height: contentView.height - 4
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        trackImageView.image = nil
    }
    
    public func configure(with viewModel: RecommendedTracksCellViewModel) {
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        trackImageView.sd_setImage(with: viewModel.imageURL)
    }
}
