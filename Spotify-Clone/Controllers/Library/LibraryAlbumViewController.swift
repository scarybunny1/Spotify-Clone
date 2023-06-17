//
//  LibraryAlbumViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 01/02/23.
//

import UIKit

class LibraryAlbumViewController: UIViewController {
    
    private var albums = [Album]()
    
    private var noAlbumsView: ActionLabelView = {
        let v =  ActionLabelView()
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private var tableView: UITableView = {
        let tv = UITableView()
        tv.isHidden = true
        return tv
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchAlbums), name: NSNotification.Name.albumSavedNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(noAlbumsView)
        noAlbumsView.delegate = self
        noAlbumsView.configure(
            model: ActionLabelViewViewModel(
                text: "You do not have any saved albums",
                actionTitle: "Browse"
            )
        )
        configureTableView()
        fetchAlbums()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        NSLayoutConstraint.activate([
            noAlbumsView.widthAnchor.constraint(equalToConstant: 200),
            noAlbumsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noAlbumsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func updateUI(){
        print(albums)
        if albums.isEmpty{
            //Show label
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        }
        else{
            //Update table with album data
            tableView.isHidden = false
            tableView.reloadData()
            noAlbumsView.isHidden = true
        }
    }
    
    private func configureTableView(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultsSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultsSubtitleTableViewCell.identifier)
    }
    
    @objc func didTapCancel(){
        dismiss(animated: true)
    }
}

extension LibraryAlbumViewController: ActionLabelViewDelegate{
    func actionLabelViewDidTapButton(_ actionLabelView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }
    
    @objc
    private func fetchAlbums(){
        APIManager.shared.getCurrentUserAlbums { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()
                case .failure(let error):
                    print("Error getting current User's albums: \(error)")
                }
            }
        }
    }
}

extension LibraryAlbumViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsSubtitleTableViewCell.identifier, for: indexPath) as! SearchResultsSubtitleTableViewCell
        let album = albums[indexPath.row]
        cell.configure(with: SearchResultsSubtitleTableViewCellViewModel(title: album.name, subTitle: album.artists.first?.name ?? "-", imageUrl: URL(string: album.images.first?.url ?? "")))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let album = albums[indexPath.row]
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        guard let navigationController = parent?.navigationController else{ return }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
