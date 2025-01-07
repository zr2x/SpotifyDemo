//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 06.01.2025.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: UI
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sigh In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemGreen
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        signInButton.frame = CGRect(x: 20,
                                    y: view.height - 50 - view.safeAreaInsets.bottom,
                                    width: view.width - 40,
                                    height: 50)
    }
    
    private func setupViews() {
        view.addSubview(signInButton)
        
        signInButton.addTarget(self, action: #selector(didTapSighIn), for: .touchUpInside)
    }
    
    private func handleSighIn(success: Bool) {
        //TODO: handler sigin
    }

    // MARK: - Actions
    @objc
    private func didTapSighIn() {
        let vc = AuthViewController()
        
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSighIn(success: success)
            }
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
