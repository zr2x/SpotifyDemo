//
//  SearchViewController.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 06.01.2025.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController, UISearchResultsUpdating {
    
    private var categories = [Category]()

    private let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Songs, Artists, Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
                return self.createLayout()
        }))
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchCategories()
    }
    
    private func fetchCategories() {
        ApiCaller.shared.getCategories { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self.categories = categories
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
    }
    
    private func createLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 7,
            bottom: 2,
            trailing: 7
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(180)),
            subitems: [item, item]
        )
        
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 0,
            bottom: 10,
            trailing: 0
        )
        
        return NSCollectionLayoutSection(group: group)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchController.searchBar.text,
              query.trimmingCharacters(in: .whitespaces).isNotEmpty else {
            return
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let category = categories[indexPath.row]
        let viewModel = CategoryCollectionViewCellViewModel(
            title: category.name,
            imageURL:
                URL(string: category.icons.first?.url ?? "")
        )
        
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let category = categories[indexPath.row]
        let vc = CategoryViewController(category: category)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let resultController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchBar.text,
              query.trimmingCharacters(in: .whitespaces).isNotEmpty else {
            return
        }
        resultController.delegate = self
        
        ApiCaller.shared.search(with: query) { [weak self] result in
            switch result {
            case .success(let results):
                resultController.update(with: results)
            case .failure(let error):
                break
            }
        }
    }
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    func didTapResult(_ result: SearchResult) {
        switch result {
        case .artist(let model):
            guard let url = URL(string: model.external_urls["spotify"] ?? "" ) else {
                return
            }
            
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        case .album(let model):
            let vc = AlbumViewController(album: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .track(let track):
            PlaybackPresenter.shared.startPlaybackTrack(from: self, track: track)
        case .playlists(let model):
            let vc = PlaylistViewController(playlist: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }

    }
}
