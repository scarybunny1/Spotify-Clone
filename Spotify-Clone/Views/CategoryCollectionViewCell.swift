//
//  SearchGenreCollectionViewCell.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 19/01/23.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchGenreCollectionViewCell"
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let genreImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .white
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
        iv.image = UIImage(systemName: "music.quarternote.3", withConfiguration: config)
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        genreLabel.text = nil
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
        genreImageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: config)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addSubview(genreImageView)
        contentView.addSubview(genreLabel)
        
        NSLayoutConstraint.activate([
            genreImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            genreImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            genreImageView.heightAnchor.constraint(equalTo: genreImageView.widthAnchor),
            genreImageView.widthAnchor.constraint(equalToConstant: 60),
            
            genreLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            genreLabel.topAnchor.constraint(equalTo: genreImageView.bottomAnchor, constant: 10),
            genreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            
        ])
    }
    
    func configure(with model: CategoryCollectionViewCellViewModel, bgColor: UIColor){
        genreLabel.text = model.title
        genreImageView.sd_setImage(with: model.artworkUrl)
        contentView.backgroundColor = bgColor
    }
}
