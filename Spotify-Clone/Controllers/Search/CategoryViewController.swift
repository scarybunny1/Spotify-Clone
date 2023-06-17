//
//  CategoryViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 20/01/23.
//

import UIKit

class CategoryViewController: UIViewController {
    
    private var category: Category
    private var playlists = [Playlist]()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)), subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }))
    
    init(category: Category){
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category.name
        setUpCollectionView()
        
        APIManager.shared.getCategoriesPlaylist(category: category) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.playlists = model
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("Error getting category playlists: \(error)")
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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeaturedPlaylistsCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier)
    }

}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier, for: indexPath) as! FeaturedPlaylistsCollectionViewCell
        let playlist = playlists[indexPath.row]
        cell.configure(with: FeaturedPlaylistsCellViewModel(name: playlist.name, description: playlist.description, artworkUrl: URL(string: playlist.images.first?.url ?? ""), ownerName: playlist.owner.display_name ))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let playlist = playlists[indexPath.row]
        let vc = PlaylistViewController(playlist: playlist)
        vc.title = playlist.name
        navigationController?.pushViewController(vc, animated: true)
    }
}
