//
//  SearchResultSubtitleTableViewCell.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 30.06.2025.
//

import UIKit

struct SearchResultSubtitleTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
}

class SearchResultSubtitleTableViewCell: UITableViewCell {
    static let identifier = "SearchResultSubtitleTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = contentView.height - 10
        iconImageView.frame = CGRect(
            x: 10,
            y: 0,
            width: imageSize,
            height: imageSize
        )
        
        iconImageView.layer.cornerRadius = imageSize / 2
        let labelHeight = contentView.height / 2
        
        label.frame = CGRect(
            x: iconImageView.right + 10,
            y: 0,
            width: contentView.width - iconImageView.right - 15,
            height: labelHeight
        )
        
        subtitleLabel.frame = CGRect(
            x: iconImageView.right + 10,
            y: label.bottom,
            width: contentView.width - iconImageView.right - 15,
            height: labelHeight
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        subtitleLabel.text = nil
    }
    
    private func setupViews() {
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
        
        for view in [label, iconImageView, subtitleLabel] {
            contentView.addSubview(view)
        }
    }
    
    func configure(with viewModel: SearchResultSubtitleTableViewCellViewModel) {
        label.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        iconImageView.sd_setImage(with: viewModel.imageURL, placeholderImage: UIImage(systemName: "photo"))
    }
}

