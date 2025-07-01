//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 06.01.2025.
//

import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}

class SearchResultsViewController: UIViewController {
    
    private var sections: [SearchSection] = []
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)

        tableView.isHidden = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    public func update(with results: [SearchResult]) {
        guard results.isNotEmpty else { return }
        
        let artists = results.filter({
            switch $0 {
            case .artist: return true
            default: return false
            }
        })
        
        let playlists = results.filter({
            switch $0 {
            case .playlists: return true
            default: return false
            }
        })
        
        let album = results.filter({
            switch $0 {
            case .album: return true
            default: return false
            }
        })
        
        let track = results.filter({
            switch $0 {
            case .track: return true
            default: return false
            }
        })
        
        sections = [
            SearchSection(title: "Artist", results: artists),
            SearchSection(title: "Playlists", results: playlists),
            SearchSection(title: "Songs", results: track),
            SearchSection(title: "Albums", results: album),
        ]
        
        tableView.reloadData()
        tableView.isHidden = false
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        
        switch result {
        case .artist(let artist):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultDefaultTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultDefaultTableViewCell else {
                return UITableViewCell()
            }
            
            let artistModel = SearchResultDefaultTableViewCellViewModel(title: artist.name, imageURL: URL(string: artist.images?.first?.url ?? "") )
            cell.configure(with: artistModel)
            return cell
        case .album(let album):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            
            let albumModel = SearchResultSubtitleTableViewCellViewModel(
                title: album.name,
                subtitle: album.artists.first?.name ?? "",
                imageURL: URL(
                    string: album.images.first?.url ?? ""
                )
            )
            cell.configure(with: albumModel)
            return cell
        case .track(let track):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            
            let trackModel = SearchResultSubtitleTableViewCellViewModel(
                title: track.name,
                subtitle: track.artists.first?.name ?? "",
                imageURL: URL(
                    string: track.album?.images.first?.url ?? ""
                )
            )
            cell.configure(with: trackModel)
            return cell
        case .playlists(let playlist):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            
            let playlistModel = SearchResultSubtitleTableViewCellViewModel(
                title: playlist.name,
                subtitle: playlist.owner.display_name,
                imageURL: URL(
                    string: playlist.images.first?.url ?? ""
                )
            )
            cell.configure(with: playlistModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResult(result)
    }
}
