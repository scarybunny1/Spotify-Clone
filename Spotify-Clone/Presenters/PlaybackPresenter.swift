//
//  PlaybackPresenter.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 22/01/23.
//

import UIKit

final class PlaybackPresenter{
    static func startPlayback(_ viewController: UIViewController, track: Track){
        let vc = PlayerViewController()
        vc.title = track.name
        viewController.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    static func startPlayback(_ viewController: UIViewController, tracks: [Track]){
        let vc = PlayerViewController()
        vc.tracks = tracks
        viewController.present(UINavigationController(rootViewController: vc), animated: true)
    }
}
