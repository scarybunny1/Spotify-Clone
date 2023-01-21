//
//  PlaylistViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 09/01/23.
//

import UIKit

class PlaylistViewController: UIViewController {

    private var playlist: Playlist
    private var viewModels = [RecommendedTracksCellViewModel]()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
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
                heightDimension: .absolute(70)
            ),
            subitem: item,
            count: 1
        )
        
        let collectionViewHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        //Section
        let s = NSCollectionLayoutSection(group: group)
        s.boundarySupplementaryItems = [collectionViewHeader]
        return s
    }))
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareButton))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        
        setUpCollectionView()
        
        APIManager.shared.getPlaylistDetails(for: playlist) {  [weak self] result in
            switch result {
            case .success(let model):
                let recommendedTracksViewModel = model.tracks.items.compactMap {
                    return RecommendedTracksCellViewModel(name: $0.track.name, disc_number: $0.track.disc_number, albumName: $0.track.album?.name ?? "--", artistName: $0.track.artists.first?.name ?? "--", duration_ms: $0.track.duration_ms, artworkUrl: URL(string: $0.track.album?.images.first?.url ?? ""))
                }
                self?.viewModels = recommendedTracksViewModel
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setUpCollectionView(){
        
        view.addSubview(collectionView)
        collectionView.register(
            RecommendedTracksCollectionViewCell.self,
            forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier
        )
        collectionView.register(
            PlaylistHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc private func didTapShareButton(){
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else{return}
        
        let activityVC = UIActivityViewController(
            activityItems: ["Hey, checkout this new playlist that I found, ", url],
            applicationActivities: []
        )
        activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityVC, animated: true)
    }
}

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier, for: indexPath) as! RecommendedTracksCollectionViewCell
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //Play song
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let playlistHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier, for: indexPath) as! PlaylistHeaderCollectionReusableView
        let headerViewModel = PlaylistHeaderViewModel(name: playlist.name, description: playlist.description, ownerName: playlist.owner.display_name, artworkURL: URL(string: playlist.images.first?.url ?? ""))
        playlistHeader.configure(with: headerViewModel)
        playlistHeader.delegate = self
        return playlistHeader
    }
}

extension PlaylistViewController: PlaylistHeaderCollectionReusableViewProtocol{
    func playlistHeaderCollectionReusableViewPlayAllTracks(_ header: PlaylistHeaderCollectionReusableView) {
        //Start playlist play all
    }
}
