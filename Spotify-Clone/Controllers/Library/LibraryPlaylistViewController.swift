//
//  LibraryPlaylistViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 01/02/23.
//

import UIKit

class LibraryPlaylistViewController: UIViewController {
    
    private var playlists = [Playlist]()
    var handleDidSelect: ((Playlist) -> Void)?
    
    private var noPlaylistsView: ActionLabelView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(noPlaylistsView)
        noPlaylistsView.delegate = self
        noPlaylistsView.configure(
            model: ActionLabelViewViewModel(
                text: "You do not have any playlists",
                actionTitle: "Create"
            )
        )
        configureTableView()
        fetchPlaylists()
        
        if handleDidSelect != nil{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        NSLayoutConstraint.activate([
            noPlaylistsView.widthAnchor.constraint(equalToConstant: 200),
            noPlaylistsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noPlaylistsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func updateUI(){
        print(playlists)
        if playlists.isEmpty{
            //Show label
            noPlaylistsView.isHidden = false
            tableView.isHidden = true
        }
        else{
            //Update table with playlist data
            tableView.isHidden = false
            tableView.reloadData()
            noPlaylistsView.isHidden = true
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

extension LibraryPlaylistViewController: ActionLabelViewDelegate{
    func actionLabelViewDidTapButton(_ actionLabelView: ActionLabelView) {
        addNewPlaylist()
    }
    
    public func addNewPlaylist(){
        let alertVC = UIAlertController(title: "New Playlist", message: "Enter name of playlist", preferredStyle: .alert)
        alertVC.addTextField{ textField in
            textField.placeholder = "Playlist..."
        }
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertVC.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alertVC.textFields?.first, let text = field.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else{
                return
            }
            
            APIManager.shared.createPlaylist(with: text) { [weak self] success in
                if success{
                    self?.fetchPlaylists()
                }
                else{
                    print("Failed to create playlist")
                }
            }
        }))
        present(alertVC, animated: true)
    }
    
    private func fetchPlaylists(){
        APIManager.shared.getCurrentUserPlaylists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                case .failure(let error):
                    print("Error getting current User's playlists: \(error)")
                }
            }
        }
    }
}

extension LibraryPlaylistViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsSubtitleTableViewCell.identifier, for: indexPath) as! SearchResultsSubtitleTableViewCell
        let playlist = playlists[indexPath.row]
        cell.configure(with: SearchResultsSubtitleTableViewCellViewModel(title: playlist.name, subTitle: playlist.owner.display_name, imageUrl: URL(string: playlist.images.first?.url ?? "")))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let playlist = playlists[indexPath.row]
        if let selectionHandler = handleDidSelect{
            selectionHandler(playlist)
            dismiss(animated: true)
        }
        else{
            let vc = PlaylistViewController(playlist: playlist)
            vc.isOwner = true
            vc.navigationItem.largeTitleDisplayMode = .never
            guard let navigationController = parent?.navigationController else{ return }
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
