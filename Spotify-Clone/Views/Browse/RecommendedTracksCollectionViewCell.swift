//
//  RecommendedTracksCollectionViewCell.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 08/01/23.
//

import UIKit
import SDWebImage

class RecommendedTracksCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTracksCollectionViewCell"
    
    private var trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private var trackImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 8
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private var trackDurationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private var stackView: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .leading
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .secondarySystemBackground
        addSubview(stackView)
        addSubview(trackImageView)
        stackView.addArrangedSubview(trackNameLabel)
        stackView.addArrangedSubview(artistNameLabel)
        addSubview(trackDurationLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            trackImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            trackImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            trackImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            trackImageView.widthAnchor.constraint(equalTo: trackImageView.heightAnchor),
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: trackImageView.trailingAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            stackView.trailingAnchor.constraint(equalTo: trackDurationLabel.leadingAnchor, constant: -5),
            
            trackDurationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            trackDurationLabel.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
        ])
    }
    
    override func prepareForReuse() {
        trackNameLabel.text = nil
        trackImageView.image = nil
        artistNameLabel.text = nil
        trackDurationLabel.text = nil
    }
    
    public func configure(with model: RecommendedTracksCellViewModel){
        trackNameLabel.text = model.name
        trackImageView.sd_setImage(with: model.artworkUrl)
        artistNameLabel.text = model.artistName
        let minutes = Int(model.duration_ms / 60000)
        let seconds = Int(model.duration_ms / 100) - minutes * 60
        trackDurationLabel.text = "\(minutes):\(seconds)"
    }
}
