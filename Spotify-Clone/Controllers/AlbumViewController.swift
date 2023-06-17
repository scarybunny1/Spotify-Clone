//
//  AlbumViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 09/01/23.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private var album: Album
    private var tracks = [Track]()
    private var viewModels = [RecommendedTracksCellViewModel]()
    
    private var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
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
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                subitem: item,
                count: 1
            )
            let section = NSCollectionLayoutSection(group: group)
            let collectionViewHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [collectionViewHeader]
            return section
        })
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        fetchData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapActionButton))
        setUpCollectionView()
    }
    
    @objc private func didTapActionButton(){
        let alertVC = UIAlertController(title: album.name, message: "What fo you want to do?", preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Save Album", style: .default, handler: { [weak self] _ in
            self?.saveAlbum()
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertVC, animated: true)
    }
    
    private func saveAlbum(){
        APIManager.shared.saveAlbum(album) { success in
            if success{
                NotificationCenter.default.post(Notification(name: Notification.Name.albumSavedNotification, object: nil))
            }
            else{
                print("Failed to save the album")
            }
        }
    }
    
    private func fetchData(){
        APIManager.shared.getAlbumDetails(for: album) { [weak self] result in
            DispatchQueue.main.async{
                switch result {
                case .success(let model):
                    self?.tracks = model.tracks.items
                    self?.viewModels = model.tracks.items.compactMap({
                        return RecommendedTracksCellViewModel(name: $0.name, disc_number: $0.disc_number, albumName: $0.album?.name ?? "", artistName: $0.artists.first?.name ?? "", duration_ms: $0.duration_ms)
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func setUpCollectionView(){
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
            
        collectionView.register(AlbumHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AlbumHeaderCollectionReusableView.identifier)
        collectionView.register(RecommendedTracksCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier)
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier, for: indexPath) as! RecommendedTracksCollectionViewCell
        cell.configure(with: viewModels[indexPath.row], hideImageView: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: AlbumHeaderCollectionReusableView.identifier, for: indexPath
        ) as! AlbumHeaderCollectionReusableView
        headerView.delegate = self
        let viewModel = AlbumHeaderViewModel(
            name: album.name,
            releaseDate: "Release date: " + String.formattedDate(from: album.release_date),
            artworkUrl: URL(string: album.images.first?.url ?? ""),
            artistName: album.artists.first?.name ?? ""
        )
        headerView.configure(with: viewModel)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        var track = tracks[indexPath.row]
        track.album = self.album
        PlaybackPresenter.shared.startPlayback(self, track: track)
    }
}

extension AlbumViewController: AlbumHeaderCollectionReusableViewProtocol{
    func albumHeaderCollectionReusableViewPlayAllTracks(_ header: AlbumHeaderCollectionReusableView) {
        let tracksWithAlbum = tracks.compactMap { [weak self] in
            var track = $0
            track.album = self?.album
            return track
        }
        PlaybackPresenter.shared.startPlayback(self, tracks: tracksWithAlbum)
    }
}
