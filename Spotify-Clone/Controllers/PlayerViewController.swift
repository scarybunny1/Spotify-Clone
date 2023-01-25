//
//  PlayerViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 22/01/23.
//

import UIKit

class PlayerViewController: UIViewController {
    
    var track: Track?
    var tracks: [Track]?
    
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .blue
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var playerControlsView = PlayerControlsView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(imageView)
        view.addSubview(playerControlsView)
        playerControlsView.delegate = self
        configureBarButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playerControlsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            playerControlsView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            playerControlsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            playerControlsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            playerControlsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func configureBarButtons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    @objc private func didTapClose(){
        self.dismiss(animated: true)
    }
    
    @objc private func didTapAction(){
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let addToPlaylistAction = UIAlertAction(title: "Add to Playlist", style: .default)
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            guard let track = self.tracks?.first, let url = URL(string: track.external_urls["spotify"] ?? "") else{return}
            
            let activityVC = UIActivityViewController(
                activityItems: ["Hey, checkout this new playlist that I found, ", url],
                applicationActivities: []
            )
            activityVC.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            self.present(activityVC, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(addToPlaylistAction)
        actionSheet.addAction(shareAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
}

extension PlayerViewController: PlayerControlsViewDelegate{
    func playerControlsViewDelegateDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        
    }
    
    func playerControlsViewDelegateDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        
    }
    
    func playerControlsViewDelegateDidTapBackwardsButton(_ playerControlsView: PlayerControlsView) {
        
    }
    
    
}
