//
//  WelcomeViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 23/12/22.
//

import UIKit

class WelcomeViewController: UIViewController {

    let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Sign In using Spotify", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var overlayView: UIView = {
        let view = UIView()
        view.layer.opacity = 0.7
        view.backgroundColor = .black
        return view
    }()
    
    private var logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private var bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "albums-bg")
        return iv
    }()
    
    private let label: UILabel = {
        let l = UILabel()
        l.text = "Listen to millions of songs on the go."
        l.textAlignment = .center
        l.numberOfLines = 0
        l.textColor = .white
        l.font = .systemFont(ofSize: 32, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .green
        view.addSubview(bgImageView)
        view.addSubview(overlayView)
        view.addSubview(label)
        view.addSubview(logoImageView)
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSigninButton), for: .touchUpInside)
    }
    
    @objc private func didTapSigninButton(){
        let vc = AuthViewController()
        vc.completionHandler = {[weak self] success in
            DispatchQueue.main.async{
                self?.handleSignin(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgImageView.frame = view.bounds
        overlayView.frame = view.bounds

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: label.bottomAnchor, multiplier: 1)
        ])
    }

    private func handleSignin(success: Bool){
        guard success else{
            let alertVC = UIAlertController(title: "Alert", message: "Oops, something went wrong while signing you in.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alertVC, animated: true)
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
        
    }
}
