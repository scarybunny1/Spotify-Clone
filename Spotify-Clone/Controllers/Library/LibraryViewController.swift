//
//  LibraryViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 23/12/22.
//

import UIKit

class LibraryViewController: UIViewController {
    
    let albumVC = LibraryAlbumViewController()
    let playlistVC = LibraryPlaylistViewController()
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let toggleView = LibraryToggleView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toggleView)
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.width*2, height: scrollView.height)
        toggleView.delegate = self
        addChildren()
        updateBarButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            toggleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toggleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toggleView.bottomAnchor.constraint(equalTo: scrollView.topAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func addChildren(){
        addChild(playlistVC)
        scrollView.addSubview(playlistVC.view)
        playlistVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        playlistVC.didMove(toParent: self)
        
        addChild(albumVC)
        scrollView.addSubview(albumVC.view)
        albumVC.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        albumVC.didMove(toParent: self)
    }
    
    private func updateBarButtons(){
        switch toggleView.state{
        case .playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        case .album:
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func didTapAddButton(){
        playlistVC.addNewPlaylist()
    }
}

extension LibraryViewController: LibraryToggleViewDelegate{
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: scrollView.width, y: 0), animated: true)
    }
}

extension LibraryViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.width - 100){
            toggleView.update(for: .album)
        }
        else if scrollView.contentOffset.x <= 100{
            toggleView.update(for: .playlist)
        }
    }
}
