//
//  LibraryToggleView.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 02.07.2025.
//

import UIKit

protocol LibraryToggleViewDelegate: AnyObject {
    func  libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView)
    func  libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView)
}

final class LibraryToggleView: UIView {
    
    enum TypeOfState {
        case playlist
        case album
    }
    
    weak var delegate: LibraryToggleViewDelegate?
    var state: TypeOfState = .playlist
    
    private let playlistButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.backgroundColor = .systemGreen
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistButton.frame = CGRect(
            x: 0,
            y: 0,
            width: 100,
            height: 40
        )
        
        albumsButton.frame = CGRect(
            x: playlistButton.right,
            y: 0,
            width: 100,
            height: 40
        )
        layoutIndicator()
    }
    
    private func layoutIndicator() {
        switch state {
        case .playlist:
            indicatorView.frame = CGRect(
                x: 0,
                y: playlistButton.bottom,
                width: 100,
                height: 3
            )
        case .album:
            indicatorView.frame = CGRect(
                x: albumsButton.right,
                y: albumsButton.bottom,
                width: 100,
                height: 3
            )
        }
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        for view in [playlistButton, albumsButton, indicatorView] {
            addSubview(view)
        }
        
        playlistButton.addTarget(self, action: #selector(didTapPlaylists), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
    }
    
    func update(for state: TypeOfState) {
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
    
    // MARK: - Actions
    @objc
    private func didTapPlaylists() {
        state = .playlist
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.libraryToggleViewDidTapPlaylists(self)
    }
    
    @objc
    private func didTapAlbums() {
        state = .album
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.libraryToggleViewDidTapAlbums(self)
    }
}
