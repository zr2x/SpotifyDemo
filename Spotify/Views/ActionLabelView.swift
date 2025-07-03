//
//  ActionLabelView.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 03.07.2025.
//

import UIKit

struct ActionLabelViewViewModel {
    let text: String
    let actionTitle: String
}

protocol ActionLabelViewDelegate: AnyObject {
    func didTapButtonActionLabelView(_ actionView: ActionLabelView)
}

final class ActionLabelView: UIView {
    
    weak var delegate: ActionLabelViewDelegate?

    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.frame = CGRect(
            x: 0,
            y: height - 40,
            width: width,
            height: 40
        )
        
        label.frame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: height - 45
        )
    }
    
    func configure(with viewModel: ActionLabelViewViewModel) {
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
    
    @objc
    private func didTapButton() {
        delegate?.didTapButtonActionLabelView(self)
    }
}
