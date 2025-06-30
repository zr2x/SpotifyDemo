//
//  CategoryCollectionViewCell.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 27.06.2025.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    private let colors: [UIColor] = [.purple, .systemBlue, .systemMint, .systemGreen]
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 50,
                weight: .regular
            )
        )
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
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
        
        label.frame = CGRect(x: 10,
                             y: contentView.height / 2,
                             width: contentView.width - 20,
                             height: contentView.height / 2
        )
        
        imageView.frame = CGRect(x: contentView.width / 2,
                                 y: 10,
                                 width: contentView.width / 2,
                                 height: contentView.height / 2
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        imageView.image = nil
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    func configure(with viewModel: CategoryCollectionViewCellViewModel) {
        label.text = viewModel.title
        imageView.sd_setImage(with: viewModel.imageURL)
        
        contentView.backgroundColor = colors.randomElement()
    }
}
