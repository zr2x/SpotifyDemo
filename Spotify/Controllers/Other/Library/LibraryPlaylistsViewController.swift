//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 02.07.2025.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {
    
    public var selectionHandler: ((Playlist) -> Void?)?

    private var playlists = [Playlist]()
    
    private let emptyPlaylistView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupEmptyView()
        fetchPlaylistsData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emptyPlaylistView.frame = CGRect(
            x: 0,
            y: 0,
            width: 150,
            height: 150
        )
        emptyPlaylistView.center = view.center
        
        tableView.frame = view.bounds
    }
    
    public func showCreatePlaylistAlert() {
        let alert = UIAlertController(title: "New playlists", message: "Enter playlist name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Playlist name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first,
                  let playListName = field.text,
                  playListName.trimmingCharacters(in: .whitespaces).isNotEmpty else {
                return
            }
            
            ApiCaller.shared.createPlaylist(with: playListName) { [weak self] success in
                if success {
                    self?.fetchPlaylistsData()
                } else {
                    print("Failed to create playlist")
                }
            }
        }))
        present(alert, animated: true)
    }
    
    private func fetchPlaylistsData() {
        ApiCaller.shared.getCurrentUserPlaylists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                case .failure(let error):
                    break
                }
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(emptyPlaylistView)
        emptyPlaylistView.delegate = self
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
    }
    
    private func setupEmptyView() {
        emptyPlaylistView.configure(
            with: ActionLabelViewViewModel(
                text: "You dont have any playlists yet",
                actionTitle: "Create")
        )
    }
    
    private func updateUI() {
        if playlists.isEmpty {
            emptyPlaylistView.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.reloadData()
            emptyPlaylistView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    @objc
    private func didTapClose() {
        dismiss(animated: true)
    }
}

extension LibraryPlaylistsViewController: ActionLabelViewDelegate {
    func didTapButtonActionLabelView(_ actionView: ActionLabelView) {
        showCreatePlaylistAlert()
    }
}

extension LibraryPlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifier,
            for: indexPath) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let playlist = playlists[indexPath.row]
        let viewModel = SearchResultSubtitleTableViewCellViewModel(
            title: playlist.name,
            subtitle: playlist.owner.display_name,
            imageURL: URL(string: playlist.images.first?.url ?? "")
        )
        
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        let vc = PlaylistViewController(playlist: playlist)
        
        guard selectionHandler == nil else {
            selectionHandler?(playlist)
            dismiss(animated: true)
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)

        vc.navigationItem.largeTitleDisplayMode = .never
        present(vc, animated: true)
    }
}
