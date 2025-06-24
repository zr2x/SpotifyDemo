//
//  ViewController.swift
//  Spotify
//
//  Created by Искандер Ситдиков on 06.01.2025.
//

import UIKit

enum BrowseSectionType {
    case newReleases(viewModels: [NewReleasesCellViewModel])
    case featuredPlaylists(viewModels: [FeaturedPlaylistCellViewModel])
    case recommendedTracks(viewModels: [RecommendedTracksCellViewModel])
}

class HomeViewController: UIViewController {
    
    private var sections = [BrowseSectionType]()
    private var newAlbums: [Album] = []
    private var playlist: [Playlist] = []
    private var tracks: [AudioTack] = []
    
    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection in
            return self.createSectionLayout(section: sectionIndex)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NewReleasesCollectionViewCell.self, forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifire)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifire)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifire)
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private var acitivityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        return spinner
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setupViews() {
        title = "Browse"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings))
        
        view.addSubview(collectionView)
        view.addSubview(acitivityIndicator)
        
    }
    
    private func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        
        switch section {
        case 0:
            return createNewReleasesLayout()
        case 1:
            return createFeaturedPlaylistsLayout()
        case 2:
            return createRecommendedTracksLayout()
        default:
            return createDefaultLayout()
        }
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponse?
        var featuredPlaylist: FeaturedPlaylistsResponse?
        var recommendations: RecomendationsResponse?
        
        // New releases
        ApiCaller.shared.getNewReleases { result in
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Featured playlists
        ApiCaller.shared.getFeaturedPlaylist { result in
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let model):
                featuredPlaylist = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Recommended tracks
        ApiCaller.shared.getRecommendedGenres { result in
            
            
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let randomElem = genres.randomElement() {
                        seeds.insert(randomElem)
                    }
                }
                
                ApiCaller.shared.getRecomendations(genres: seeds) { recommendedResult in
                    defer {
                        group.leave()
                    }
                    switch recommendedResult {
                    case .success(let model):
                        recommendations = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) {
            guard let newAlbums = newReleases?.albums.items,
                  let playlist = featuredPlaylist?.playlist.items,
                  let tracks = recommendations?.tracks else {
                return
            }
            self.configureModels(newAlbums: newAlbums, playlist: playlist, tracks: tracks)
        }
    }
    
    private func configureModels(newAlbums: [Album], playlist: [Playlist], tracks: [AudioTack]) {
        self.newAlbums = newAlbums
        self.playlist = playlist
        self.tracks = tracks
        
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            NewReleasesCellViewModel(name: $0.name,
                                     artWorkURL: URL(string: $0.images.first?.url ?? ""),
                                     numberOfTracks: $0.total_tracks,
                                     artistName: $0.artist.first?.name ?? "-"
            )})))
        sections.append(.featuredPlaylists(viewModels: playlist.compactMap({
            FeaturedPlaylistCellViewModel(playlistName: $0.name,
                                          imageURL: URL(string: $0.images.first?.url ?? ""),
                                          creatorName: $0.owner.display_name
            )
        })))
        sections.append(.recommendedTracks(viewModels: tracks.compactMap({
            RecommendedTracksCellViewModel(trackName: $0.name,
                                           artistName: $0.artists.first?.name ?? "-",
                                           imageURL: URL(string: $0.album?.images.first?.url ?? "")
            )
        })))
        collectionView.reloadData()
    }
    
    @objc
    private func didTapSettings() {
        let vc = SettingsViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - NSCollectionLayoutSection
    
    private func createNewReleasesLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(120)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(120 * 3)
            ),
            repeatingSubitem: item,
            count: 3
        )
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.9),
                heightDimension: .absolute(verticalGroup.layoutSize.heightDimension.dimension)
            ),
            repeatingSubitem: verticalGroup,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func createFeaturedPlaylistsLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(200),
                heightDimension: .absolute(200)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(200),
                heightDimension: .absolute(400)
            ),
            repeatingSubitem: item,
            count: 2
        )
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(200),
                heightDimension: .absolute(400)
            ),
            repeatingSubitem: verticalGroup,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private func createRecommendedTracksLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(80)
            ),
            repeatingSubitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func createDefaultLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(120)
            ),
            repeatingSubitem: item,
            count: 1
        )
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type =  sections[section]
        switch type {
        case .featuredPlaylists(let viewModel):
            return viewModel.count
        case .newReleases(let viewModel):
            return viewModel.count
        case .recommendedTracks(let viewModel):
            return viewModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type =  sections[indexPath.section]
        
        switch type {
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleasesCollectionViewCell.identifire,
                for: indexPath) as? NewReleasesCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .featuredPlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifire,
                for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .red
            let viewmodel = viewModels[indexPath.row]
            cell.configure(with: viewmodel)
            return cell
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedTrackCollectionViewCell.identifire,
                for: indexPath) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .blue
            let viewmodel = viewModels[indexPath.row]
            cell.configure(with: viewmodel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        switch section {
        case .featuredPlaylists:
            let playlist = playlist[indexPath.row]
            let albumVC = PlaylistViewController(playlist: playlist)
            albumVC.navigationItem.largeTitleDisplayMode = .never
            
            navigationController?.pushViewController(albumVC, animated: true)
        case .newReleases:
            let album = newAlbums[indexPath.row]
            let albumVC = AlbumViewController(album: album)
            albumVC.navigationItem.largeTitleDisplayMode = .never
            
            navigationController?.pushViewController(albumVC, animated: true)
        case .recommendedTracks:
            let item = tracks[indexPath.row]
        }
    }
}
