//
//  HomeViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 23/12/22.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(didTapSettingsButton))
        
//        APIManager.shared.getNewReleases { result in
//            switch result{
//            case .success(let model):
//                break
//            case.failure(let error):
//                print(error)
//            }
//        }
//
//        APIManager.shared.getFeaturedPlaylists { result in
//            switch result {
//            case .success(let model):
//                break
//            case .failure(let error):
//                break
//            }
//        }
        
        APIManager.shared.getRecommendedGenres { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var genreSeedList: [String] = []
                for _ in 1...5{
                    genreSeedList.append(genres[Int.random(in: 0..<genres.count)])
                }
                APIManager.shared.getRecommendations(genreSeed: genreSeedList) { result in
                    switch result {
                    case .success(let model):
                        break
                    case .failure(let failure):
                        break
                    }
                }
                break
            case .failure(let failure):
                break
            }
        }
        
        
    }
    
    @objc private func didTapSettingsButton(){
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
