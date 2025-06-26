//
//  TitleHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 26.06.2025.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "TitleHeaderCollectionReusableView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 15, y: 0, width: width - 30, height: height)
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        addSubview(titleLabel)
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
