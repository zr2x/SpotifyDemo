//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 02.07.2025.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {

    private var albums = [Album]()
    
    private let emptyAlbumsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupEmptyView()
        fetchAlbumsData()
        setupObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emptyAlbumsView.frame = CGRect(
            x: (view.width - 150) / 2,
            y: (view.height - 150) / 2,
            width: 150,
            height: 150
        )
        emptyAlbumsView.center = view.center
        
        tableView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height: view.height
        )
    }
    
    private func fetchAlbumsData() {
        albums.removeAll()
        ApiCaller.shared.getCurrentUserAlbums { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(emptyAlbumsView)
        emptyAlbumsView.delegate = self
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupEmptyView() {
        emptyAlbumsView.configure(
            with: ActionLabelViewViewModel(
                text: "You have not saved any albums yet",
                actionTitle: "Browse")
        )
    }
    
    private func setupObserver() {
        observer = NotificationCenter.default.addObserver(
            forName: .albumSavedNotification,
            object: nil,
            queue: .main,
            using: { _ in
                self.fetchAlbumsData()
        })
    }
    
    private func updateUI() {
        if albums.isEmpty {
            emptyAlbumsView.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.reloadData()
            emptyAlbumsView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    @objc
    private func didTapClose() {
        dismiss(animated: true)
    }
}

extension LibraryAlbumsViewController: ActionLabelViewDelegate {
    func didTapButtonActionLabelView(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }
}

extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifier,
            for: indexPath) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let album = albums[indexPath.row]
        let viewModel = SearchResultSubtitleTableViewCellViewModel(
            title: album.name,
            subtitle: album.artists.first?.name ?? "",
            imageURL: URL(string: album.images.first?.url ?? "")
        )
        
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let album = albums[indexPath.row]

        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        present(vc, animated: true)
    }
}
