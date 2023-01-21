//
//  AlbumHeaderCollectionReusableView.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 14/01/23.
//

import UIKit

protocol AlbumHeaderCollectionReusableViewProtocol{
    func albumHeaderCollectionReusableViewPlayAllTracks(_ header: AlbumHeaderCollectionReusableView)
}

class AlbumHeaderCollectionReusableView: UICollectionReusableView {
    static var identifier = "AlbumHeaderCollectionReusableView"
    
    var delegate: AlbumHeaderCollectionReusableViewProtocol?
    
    var verStackView: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 10
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var horStackView: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 10
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "photo")
        return iv
    }()
    
    private var playAllButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .regular))
        button.setImage(image, for: .normal)
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        button.layer.cornerRadius = 25
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(horStackView)
        horStackView.addArrangedSubview(verStackView)
        horStackView.addArrangedSubview(playAllButton)
        
        addSubview(nameLabel)
        verStackView.addArrangedSubview(releaseDateLabel)
        verStackView.addArrangedSubview(ownerLabel)
        
        playAllButton.addTarget(self, action: #selector(didTapPlayAllButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 1.8),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            horStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            horStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            horStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: horStackView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: horStackView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: horStackView.topAnchor, constant: 10),
            
            playAllButton.heightAnchor.constraint(equalToConstant: 50),
            playAllButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configure(with model: AlbumHeaderViewModel){
        nameLabel.text = model.name
        ownerLabel.text = model.artistName
        releaseDateLabel.text = model.releaseDate
        imageView.sd_setImage(with: model.artworkUrl)
    }
    
    @objc private func didTapPlayAllButton(){
        self.delegate?.albumHeaderCollectionReusableViewPlayAllTracks(self)
    }
}
