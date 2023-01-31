//
//  PlayerControlsView.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 24/01/23.
//

import UIKit

struct PlayerControlsViewViewModel{
    let title: String
    let subtitle: String
}

protocol PlayerControlsViewDelegate: AnyObject{
    func playerControlsViewDelegateDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDelegateDidTapForwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDelegateDidTapBackwardsButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDelegate(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float)
}

protocol PlayerViewControllerDatasource: AnyObject{
    var songName: String? { get }
    var subtitle: String? { get }
    var imageUrl: URL? { get }
}

class PlayerControlsView: UIView {
    
    weak var delegate: PlayerControlsViewDelegate?
    private var isPlaying = true
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        label.text = "Hello"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 1
        label.text = "Adele"
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let prevButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(
            UIImage(
                systemName: "backward.fill",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 34,
                    weight: .regular
                )
            ),
            for: .normal
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(
            UIImage(
                systemName: "forward.fill",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 34,
                    weight: .regular
                )
            ),
            for: .normal
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(
            UIImage(
                systemName: "pause.fill",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 34,
                    weight: .regular
                )
            ),
            for: .normal
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var playbackStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        return sv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        addSubview(playbackStackView)
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(volumeSlider)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider), for: .valueChanged)
        playbackStackView.addArrangedSubview(prevButton)
        playbackStackView.addArrangedSubview(playPauseButton)
        playbackStackView.addArrangedSubview(nextButton)
        
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapForwardButton), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(didTapBackwardsButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            volumeSlider.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10),
            volumeSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            volumeSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            playbackStackView.topAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: 20),
            playbackStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            playbackStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            playbackStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configureView(with model: PlayerControlsViewViewModel){
        nameLabel.text = model.title
        subtitleLabel.text = model.subtitle
    }
    
    @objc private func didTapPlayPauseButton(){
        delegate?.playerControlsViewDelegateDidTapPlayPauseButton(self)
        isPlaying = !isPlaying
        
        let playIcon = UIImage(
            systemName: "play.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 34,
                weight: .regular
            )
        )
        let pauseIcon = UIImage(
            systemName: "pause.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 34,
                weight: .regular
            )
        )
        
        playPauseButton.setImage(isPlaying ? pauseIcon : playIcon, for: .normal)
    }
    
    @objc private func didTapForwardButton(){
        delegate?.playerControlsViewDelegateDidTapPlayPauseButton(self)
    }
    
    @objc private func didTapBackwardsButton(){
        delegate?.playerControlsViewDelegateDidTapPlayPauseButton(self)
    }
    
    @objc func didSlideSlider(_ slider: UISlider){
        let value = slider.value
        delegate?.playerControlsViewDelegate(self, didSlideSlider: value)
    }
}
