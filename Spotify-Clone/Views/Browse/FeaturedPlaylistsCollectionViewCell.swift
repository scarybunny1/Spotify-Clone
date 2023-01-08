//
//  FeaturedPlaylistsCollectionViewCell.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 08/01/23.
//

import UIKit
//var name: String
//var description: String
//var artworkUrl: URL?
//var owner: String

class FeaturedPlaylistsCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistsCollectionViewCell"
    
    private var playlistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var playlistImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 8
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private var ownerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(playlistImageView)
        addSubview(playlistNameLabel)
        addSubview(ownerLabel)
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            playlistImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            playlistImageView.heightAnchor.constraint(equalTo: heightAnchor, constant: -70),
            playlistImageView.widthAnchor.constraint(equalTo: playlistImageView.heightAnchor),
            playlistImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            playlistNameLabel.topAnchor.constraint(equalTo: playlistImageView.bottomAnchor, constant: 5),
            playlistNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -5),
            playlistNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            ownerLabel.topAnchor.constraint(equalTo: playlistNameLabel.bottomAnchor, constant: 5),
            ownerLabel.leadingAnchor.constraint(equalTo: playlistNameLabel.leadingAnchor),
            ownerLabel.trailingAnchor.constraint(equalTo: playlistNameLabel.trailingAnchor),
            ownerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    override func prepareForReuse() {
        playlistNameLabel.text = nil
        playlistImageView.image = nil
        ownerLabel.text = nil
    }
    
    public func configure(with model: FeaturedPlaylistsCellViewModel){
        playlistNameLabel.text = model.name
        playlistImageView.sd_setImage(with: model.artworkUrl)
        ownerLabel.text = model.ownerName
    }
}
