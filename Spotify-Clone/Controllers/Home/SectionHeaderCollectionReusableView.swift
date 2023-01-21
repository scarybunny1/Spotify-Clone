//
//  SectionHeaderCollectionReusableView.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 14/01/23.
//

import UIKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {
    static var identifier = "SectionHeaderCollectionReusableView"
    
    private var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        headerLabel.frame = bounds
    }
    
    func configure(with title: String){
        self.headerLabel.text = title
    }
}
