//
//  SearchViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 23/12/22.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController {
    
    var categories = [Category]()

    let searchController: UISearchController = {
        let resultsVC = SearchResultsViewController()
        let vc = UISearchController(searchResultsController: resultsVC)
        vc.searchBar.placeholder = "Songs, Artists, Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 8,
            bottom: 2,
            trailing: 8
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitem: item,
            count: 2
        )
        
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 2,
            bottom: 10,
            trailing: 2
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }))
    
    //MARK:  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        setUpCollectionView()
        APIManager.shared.getCategories { [weak self] result in
            DispatchQueue.main.async{
                switch result {
                case .success(let model):
                    self?.categories = model.categories.items
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("Error getting categories data: \(error)")
                }
            }
        }
    }

    private func setUpCollectionView(){
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let vc = searchController.searchResultsController as? SearchResultsViewController,
                let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        vc.delegate = self
        //API Search
        APIManager.shared.search(query: query) { result in
            DispatchQueue.main.async{
                switch result {
                case .success(let searchResults):
                    vc.update(with: searchResults)
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.row]
        cell.configure(with: CategoryCollectionViewCellViewModel(title: category.name, artworkUrl: URL(string: category.icons.first?.url ?? "")))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let vc = CategoryViewController(category: category)
        vc.title = category.name
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: SearchResultsViewControllerDelegate{
    func didTapResult(_ result: SearchResults) {
        switch result{
        case .tracks(let track):
            PlaybackPresenter.shared.startPlayback(self, track: track)
        case .albums(let album):
            let vc = AlbumViewController(album: album)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .artists(let artist):
            guard let url = URL(string: artist.external_urls["spotify"] ?? "") else{
                return
            }
            self.openArtistDetailsInWebView(url: url)
        case .playlists(let playlist):
            let vc = PlaylistViewController(playlist: playlist)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func openArtistDetailsInWebView(url: URL){
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}
