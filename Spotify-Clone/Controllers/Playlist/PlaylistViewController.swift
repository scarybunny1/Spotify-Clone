//
//  PlaylistViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 09/01/23.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    var isOwner = false
    private var playlist: Playlist
    private var tracks = [Track]()
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
        addLongPressGesture()
        
        APIManager.shared.getPlaylistDetails(for: playlist) {[weak self] result in
            DispatchQueue.main.async{
                switch result {
                case .success(let model):
                    self?.tracks = model.tracks.items.compactMap({ $0.track })
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
    
    private func addLongPressGesture(){
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:))))
    }
    
    @objc private func didLongPress(_ gesture: UILongPressGestureRecognizer){
        guard gesture.state == .began else{
            return
        }
        
        let point = gesture.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point){
            let track = tracks[indexPath.row]
            
            let actionSheet = UIAlertController(title: track.name, message: "Do you want to remove this track from the \(playlist.name)", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak self] _ in
                guard let self = self else{return}
                APIManager.shared.removeTrackFromPlaylist(track: track, playlist: self.playlist) { success in
                    DispatchQueue.main.async{
                        if success{
                            self.tracks.remove(at: indexPath.row)
                            self.viewModels.remove(at: indexPath.row)
                            self.collectionView.reloadData()
                        }
                    }
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(actionSheet, animated: true)
        }
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
        PlaybackPresenter.shared.startPlayback(self, track: tracks[indexPath.row])
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
        PlaybackPresenter.shared.startPlayback(self, tracks: tracks)
    }
}
