//
//  SearchResultsSubtitleTableViewCell.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 22/01/23.
//

import UIKit

struct SearchResultsSubtitleTableViewCellViewModel{
    let title: String
    let subTitle: String
    let imageUrl: URL?
}

class SearchResultsSubtitleTableViewCell: UITableViewCell {

    static let identifier = "SearchResultsSubtitleTableViewCell"
    
    private var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            iconImageView.heightAnchor.constraint(equalToConstant: 60),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            stackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            stackView.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subTitleLabel.text = nil
        iconImageView.image = nil
    }
    
    func configure(with model: SearchResultsSubtitleTableViewCellViewModel){
        self.titleLabel.text = model.title
        self.subTitleLabel.text = model.subTitle
        self.iconImageView.sd_setImage(with: model.imageUrl, placeholderImage: UIImage(systemName: "music.note.list"))
    }
}
