//
//  ActionLabelView.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 05/02/23.
//

import UIKit

struct ActionLabelViewViewModel{
    let text: String
    let actionTitle: String
}

protocol ActionLabelViewDelegate{
    func actionLabelViewDidTapButton(_ actionLabelView: ActionLabelView)
}

class ActionLabelView: UIView{
    
    var delegate: ActionLabelViewDelegate?
    
    private let label: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .secondaryLabel
        return l
    }()
    
    private let button: UIButton = {
        let b = UIButton()
        b.setTitleColor(.link, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(label)
        addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.centerXAnchor.constraint(equalTo: label.centerXAnchor)
        ])
    }
    
    @objc private func didTapButton(){
        delegate?.actionLabelViewDidTapButton(self)
    }
    
    func configure(model: ActionLabelViewViewModel){
        label.text = model.text
        button.setTitle(model.actionTitle, for: .normal)
    }
}
