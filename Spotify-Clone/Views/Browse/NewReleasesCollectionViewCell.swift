//
//  NewReleasesCollectionViewCell.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 08/01/23.
//

import UIKit
import SDWebImage

class NewReleasesCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleasesCollectionViewCell"
    
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: CGFloat(22), weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    private var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: CGFloat(18), weight: .semibold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private var numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: CGFloat(14), weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private var albumCoverImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .secondarySystemBackground
        addSubview(albumCoverImageView)
        addSubview(albumNameLabel)
        addSubview(artistNameLabel)
        addSubview(numberOfTracksLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
        albumCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfTracksLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            albumCoverImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            albumCoverImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            albumCoverImageView.heightAnchor.constraint(equalTo: heightAnchor, constant: -10),
            albumCoverImageView.widthAnchor.constraint(equalTo: albumCoverImageView.heightAnchor),
            
            albumNameLabel.topAnchor.constraint(equalTo: albumCoverImageView.topAnchor),
            albumNameLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: 10),
            albumNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 5),
            artistNameLabel.trailingAnchor.constraint(equalTo: albumNameLabel.trailingAnchor),
            artistNameLabel.leadingAnchor.constraint(equalTo: albumNameLabel.leadingAnchor),
            
            numberOfTracksLabel.bottomAnchor.constraint(equalTo: albumCoverImageView.bottomAnchor, constant: -5),
            numberOfTracksLabel.leadingAnchor.constraint(equalTo: albumNameLabel.leadingAnchor),
            numberOfTracksLabel.trailingAnchor.constraint(equalTo: albumNameLabel.trailingAnchor),
            numberOfTracksLabel.topAnchor.constraint(greaterThanOrEqualTo: artistNameLabel.bottomAnchor, constant: 10)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    public func configure(with model: NewReleasesCellViewModel){
        albumNameLabel.text = model.name
        artistNameLabel.text = model.artistName
        numberOfTracksLabel.text = "Tracks: \(model.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: model.artworkUrl)
    }
}
