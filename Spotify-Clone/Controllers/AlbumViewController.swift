//
//  AlbumViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 09/01/23.
//

import UIKit

class AlbumViewController: UIViewController {

    private var album: Album
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        APIManager.shared.getAlbumDetails(for: album) { result in
            switch result {
            case .success(let model):
                print(model)
            case .failure(let error):
                print(error)
            }
        }
    }

}
