//
//  NewReleasesCollectionViewCell.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 20.06.2025.
//

import UIKit
import SDWebImage

final class NewReleasesCollectionViewCell: UICollectionViewCell {
    
    private var albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)

        return label
    }()
    
    private var numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .thin)

        return label
    }()
    
    private var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    

    
    static let identifire = "NewReleasesCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.clipsToBounds = true
        
        for view in [albumImageView, albumNameLabel, artistNameLabel, numberOfTracksLabel] {
            contentView.addSubview(view)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 10
        let albumLabelSize = albumNameLabel.sizeThatFits(
            CGSize(
                width: contentView.width - imageSize - 10,
                height: contentView.height - 10
            )
        )
        
        albumNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        
        albumImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
        let albumLabelHeight = min(70, albumLabelSize.height)
        albumNameLabel.frame = CGRect(x: albumImageView.right + 10,
                                      y: 5,
                                      width: albumLabelSize.width,
                                      height: albumLabelHeight
        )
        
        artistNameLabel.frame = CGRect(x: albumImageView.right + 10,
                                       y: artistNameLabel.bottom,
                                       width: contentView.width - albumImageView.right - 10,
                                      height: 30
        )
        
        numberOfTracksLabel.frame = CGRect(x: albumImageView.right + 10,
                                           y: contentView.bottom - 44,
                                      width: numberOfTracksLabel.width,
                                      height: 44
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumImageView.image = nil
    }
    
    public func configure(with viewModel: NewReleasesCellViewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        
        albumImageView.sd_setImage(with: viewModel.artWorkURL)
    }
}
