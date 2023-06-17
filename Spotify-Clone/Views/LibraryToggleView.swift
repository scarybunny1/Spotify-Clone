//
//  LibraryToggleView.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 01/02/23.
//

import UIKit

protocol LibraryToggleViewDelegate{
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView)
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView)
    
}

class LibraryToggleView: UIView {
    
    enum State{
        case playlist
        case album
    }
    
    var state: State = .playlist
    
    private let playlistButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlist", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let albumButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Album", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var delegate: LibraryToggleViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(playlistButton)
        addSubview(albumButton)
        addSubview(indicatorView)
        
        playlistButton.addTarget(self, action: #selector(didTapPlaylistsButton), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(didTapAlbumsButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            playlistButton.heightAnchor.constraint(equalToConstant: 50),
            playlistButton.widthAnchor.constraint(equalTo: playlistButton.heightAnchor, multiplier: 2.5),
            playlistButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            playlistButton.topAnchor.constraint(equalTo: topAnchor),
            
            albumButton.leadingAnchor.constraint(equalTo: playlistButton.trailingAnchor, constant: 10),
            albumButton.widthAnchor.constraint(equalTo: albumButton.heightAnchor, multiplier: 2.5),
            albumButton.heightAnchor.constraint(equalToConstant: 50),
            albumButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            albumButton.topAnchor.constraint(equalTo: topAnchor),
        ])
        
        layoutIndicatorView()
    }
    
    @objc private func didTapPlaylistsButton(){
        delegate?.libraryToggleViewDidTapPlaylists(self)
    }
    
    @objc private func didTapAlbumsButton(){
        delegate?.libraryToggleViewDidTapAlbums(self)
    }
    
    private func layoutIndicatorView(){
        let frame: CGRect
        switch self.state{
        case .playlist:
            frame = CGRect(x: 0, y: playlistButton.bottom, width: playlistButton.width, height: 3)
        case .album:
            frame = CGRect(x: albumButton.left, y: playlistButton.bottom, width: playlistButton.width, height: 3)
        }
        UIView.animate(withDuration: 0.2) {
            self.indicatorView.frame = frame
        }
    }
    
    func update(for state: State){
        self.state = state
        layoutIndicatorView()
    }
}
