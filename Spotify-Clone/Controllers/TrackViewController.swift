//
//  TrackDetailsViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 09/01/23.
//

import UIKit

class TrackViewController: UIViewController {

    private var track: Track
    
    init(track: Track) {
        self.track = track
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = track.name
        
//        APIManager.shared.getTrackDetails(for: track) { result in
//            switch result {
//            case .success(let model):
//                print(model)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }

}
