//
//  SearchResultDefaultTableViewCell.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 30.06.2025.
//

import UIKit

final class SearchResultDefaultTableViewCell: UITableViewCell {
    static let identifier = "SearchResultDefaultTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        
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

        label.frame = CGRect(
            x: iconImageView.right + 10,
            y: 0,
            width: contentView.width - iconImageView.right - 15,
            height: contentView.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
    }
    
    private func setupViews() {
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
        for view in [label, iconImageView] {
            contentView.addSubview(view)
        }
    }
    
    func configure(with viewModel: SearchResultDefaultTableViewCellViewModel) {
        label.text = viewModel.title
        iconImageView.sd_setImage(with: viewModel.imageURL)
    }
}
