//
//  PlayerViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 22/01/23.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate: AnyObject{
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider(_ value: Float)
}

class PlayerViewController: UIViewController {
    
    weak var datasource: PlayerViewControllerDatasource?
    weak var delegate: PlayerViewControllerDelegate?
    
    private var imageView: UIImageView = {
        let iv = UIImageView()
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
        configure()
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
    
    private func configure(){
        imageView.sd_setImage(with: datasource?.imageUrl)
        playerControlsView.configureView(with: PlayerControlsViewViewModel(title: datasource?.songName ?? "", subtitle: datasource?.subtitle ?? ""))
    }
    
    @objc private func didTapClose(){
        self.dismiss(animated: true)
    }
    
    @objc private func didTapAction(){
        let actionSheet = UIAlertController(title: datasource?.songName, message: "What do you want to do?", preferredStyle: .actionSheet)
        
        let addToPlaylistAction = UIAlertAction(title: "Add to Playlist", style: .default)
        let shareAction = UIAlertAction(title: "Share", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(addToPlaylistAction)
        actionSheet.addAction(shareAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    func refreshUI(){
        configure()
    }
}

extension PlayerViewController: PlayerControlsViewDelegate{
    func playerControlsViewDelegateDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        self.delegate?.didTapPlayPause()
    }
    
    func playerControlsViewDelegateDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        self.delegate?.didTapForward()
    }
    
    func playerControlsViewDelegateDidTapBackwardsButton(_ playerControlsView: PlayerControlsView) {
        self.delegate?.didTapBackward()
    }
    
    func playerControlsViewDelegate(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        self.delegate?.didSlideSlider(value)
    }
}
