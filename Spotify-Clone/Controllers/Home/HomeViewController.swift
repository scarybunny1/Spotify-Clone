//
//  HomeViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 23/12/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    enum BrowseSectionType{
        case newReleases(viewModel: [NewReleasesCellViewModel])
        case featuredPlaylists(viewModel: [FeaturedPlaylistsCellViewModel])
        case recommendedTracks(viewModel: [RecommendedTracksCellViewModel])
        
        var title: String{
            switch self{
            case .newReleases:
                return "New Releases"
            case .featuredPlaylists:
                return "Featured Playlists"
            case .recommendedTracks:
                return "Recommended Tracks"
            }
        }
    }
    
    private var collectionView: UICollectionView!
    
    private var spinner: UIActivityIndicatorView = {
        let s = UIActivityIndicatorView()
        s.tintColor = .label
        s.hidesWhenStopped = true
        return s
    }()
    
    private var sections = [BrowseSectionType]()
    
    private var playlists = [Playlist]()
    private var tracks = [Track]()
    private var albums = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSectionLayout(section: sectionIndex)
        }
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(
                systemName: "gear"
            ),
            style: .plain,
            target: self,
            action: #selector(didTapSettingsButton)
        )
        
        configureCollectionView()
        view.addSubview(spinner)
        
        var newReleases: NewReleasesResponse?
        var recommendations: RecommendationsResponse?
        var featuredPlaylists: FeaturedPlaylistsResponse?
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        APIManager.shared.getNewReleases { result in
            
            defer{
                group.leave()
            }
            
            switch result{
            case .success(let model):
                newReleases = model
            case.failure(let error):
                print(error)
            }
        }
        
        APIManager.shared.getFeaturedPlaylists { result in
            
            defer{
                group.leave()
            }
            
            switch result {
            case .success(let model):
                featuredPlaylists = model
            case .failure(let error):
                print(error)
            }
        }
        
        APIManager.shared.getRecommendedGenres { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var genreSeedList: [String] = []
                for _ in 1...5{
                    genreSeedList.append(genres[Int.random(in: 0..<genres.count)])
                }
                APIManager.shared.getRecommendations(genreSeed: genreSeedList) { result in
                    
                    defer{
                        group.leave()
                    }
                    
                    switch result {
                    case .success(let model):
                        recommendations = model
                    case .failure(let error):
                        print(error)
                    }
                }
                break
            case .failure(let error):
                print(error)
            }
        }
        
        group.notify(queue: .main) {[weak self] in
            guard let self = self,
                    let albums = newReleases?.albums.items,
                    let playlists = featuredPlaylists?.playlists.items,
                    let tracks = recommendations?.tracks
            else{
                return
            }
            self.configureModels(albums: albums, playlists: playlists, tracks: tracks)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        collectionView.register(
            NewReleasesCollectionViewCell.self,
            forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier
        )
        collectionView.register(
            RecommendedTracksCollectionViewCell.self,
            forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier
        )
        collectionView.register(
            FeaturedPlaylistsCollectionViewCell.self,
            forCellWithReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier
        )
        collectionView.register(
            SectionHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderCollectionReusableView.identifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func configureModels(albums: [Album], playlists: [Playlist], tracks: [Track]){
        self.albums = albums
        self.playlists = playlists
        self.tracks = tracks
        
        self.sections.append(.newReleases(viewModel: albums.compactMap({
            return NewReleasesCellViewModel(
                name: $0.name,
                artworkUrl: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.total_tracks,
                artistName: $0.artists.first?.name ?? ""
            )
        })))
        self.sections.append(.featuredPlaylists(viewModel: playlists.compactMap({
            return FeaturedPlaylistsCellViewModel(
                name: $0.name,
                description: $0.description,
                artworkUrl: URL(string: $0.images.first?.url ?? ""),
                ownerName: $0.owner.display_name
            )
        })))
        self.sections.append(.recommendedTracks(viewModel: tracks.compactMap({
            return RecommendedTracksCellViewModel(
                name: $0.name,
                disc_number: $0.disc_number,
                albumName: $0.album?.name ?? "",
                artistName: $0.artists.first?.name ?? "",
                duration_ms: $0.duration_ms,
                artworkUrl: URL(string: $0.album?.images.first?.url ?? "")
            )
        })))
        self.collectionView.reloadData()
    }
    
    @objc private func didTapSettingsButton(){
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType{
        case .newReleases(let viewModel):
            return viewModel.count
        case .featuredPlaylists(let viewModel):
            return viewModel.count
        case .recommendedTracks(let viewModel):
            return viewModel.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        
        switch type{
        case .newReleases(let viewModel):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleasesCollectionViewCell.identifier,
                for: indexPath
            ) as! NewReleasesCollectionViewCell
            cell.configure(with: viewModel[indexPath.row])
            return cell
        case.recommendedTracks(let viewModel):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier,
                for: indexPath
            ) as! RecommendedTracksCollectionViewCell
            cell.configure(with: viewModel[indexPath.row])
            return cell
        case .featuredPlaylists(let viewModel):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier,
                for: indexPath
            ) as! FeaturedPlaylistsCollectionViewCell
            cell.configure(with: viewModel[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        switch sections[indexPath.section]{
        case .newReleases(_):
            let album = self.albums[indexPath.row]
            let albumVC = AlbumViewController(album: album)
            albumVC.title = album.name
            albumVC.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(albumVC, animated: true)
            
        case .featuredPlaylists(_):
            let playlist = playlists[indexPath.row]
            let playlistVC = PlaylistViewController(playlist: playlist)
            playlistVC.title = playlist.name
            playlistVC.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(playlistVC, animated: true)
        case .recommendedTracks(_):
            let track = tracks[indexPath.row]
            let trackVC = TrackViewController(track: track)
            trackVC.title = track.name
            trackVC.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(trackVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderCollectionReusableView.identifier, for: indexPath) as! SectionHeaderCollectionReusableView
        let section = sections[indexPath.section]
        headerView.configure(with: section.title)
        return headerView
    }
    
    func createSectionLayout(section: Int) -> NSCollectionLayoutSection{
        let supplementaryItem = [NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )]
        
        switch section{
        case 0:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2
            )
            //Vertical group inside of a horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(390)),
                subitem: item, count: 3
            )
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(390)
                ),
                subitem: verticalGroup, count: 1
            )
            
            //Section
            let s = NSCollectionLayoutSection(group: horizontalGroup)
            s.orthogonalScrollingBehavior = .groupPaging
            s.boundarySupplementaryItems = supplementaryItem
            return s
        case 1:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(200)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2
            )
            //Vertical group inside of a horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitem: item,
                count: 2
            )
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitem: verticalGroup,
                count: 1
            )
            
            //Section
            let s = NSCollectionLayoutSection(group: horizontalGroup)
            s.orthogonalScrollingBehavior = .continuous
            s.boundarySupplementaryItems = supplementaryItem
            return s
        case 2:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2
            )
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(100)
                ),
                subitem: item,
                count: 1
            )
            
            //Section
            let s = NSCollectionLayoutSection(group: group)
            s.boundarySupplementaryItems = supplementaryItem
            return s
        default:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2
            )
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 1
            )
            
            //Section
            let s = NSCollectionLayoutSection(group: group)
            s.boundarySupplementaryItems = supplementaryItem
            return s
        }
    }
}
