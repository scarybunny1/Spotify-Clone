//
//  PlaybackPresenter.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 22/01/23.
//

import UIKit
import AVFoundation


final class PlaybackPresenter{
    
    static let shared = PlaybackPresenter()
    var index = 0
    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    var playerVC: PlayerViewController?
    
    private var track: Track?
    private var tracks = [Track]()
    private var currentTrack: Track? {
        if let track = track, tracks.isEmpty{
            return track
        }
        else if let player = playerQueue, !tracks.isEmpty{
            let item = player.currentItem
            let items = player.items()
            
            guard let index = items.firstIndex(where: {$0 == item}) else{
                 return nil
            }
            return tracks[index]
        }
        return nil
    }
    
    func startPlayback(_ viewController: UIViewController, track: Track){
        guard let url = URL(string: track.preview_url ?? "") else{
            return
        }
        player = AVPlayer(url: url)
        player?.volume = 0.5
        self.tracks = []
        self.track = track
        
        
        let vc = PlayerViewController()
        vc.datasource = self
        vc.delegate = self
        self.playerVC = vc
        viewController.present(UINavigationController(rootViewController: vc), animated: true) {[weak self] in
            self?.player?.play()
        }
    }
    
    func startPlayback(_ viewController: UIViewController, tracks: [Track]){
        self.tracks = tracks
        self.track = nil
        
        let items: [AVPlayerItem] = tracks.compactMap { track in
            guard let url = URL(string: track.preview_url ?? "") else{
                return nil
            }
            return AVPlayerItem(url: url)
        }
        self.playerQueue = AVQueuePlayer(items: items)
        self.playerQueue?.volume = 0.5
        self.playerQueue? .play()
        
        let vc = PlayerViewController()
        self.playerVC = vc
        vc.datasource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true)
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate{
    func didSlideSlider(_ value: Float) {
        if let player = player{
            player.volume = value
        }
        else if let player = playerQueue{
            player.volume = value
        }
    }
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing{
                player.pause()
            }
            else{
                player.play()
            }
        }
        else if let player = playerQueue{
            if player.timeControlStatus == .playing{
                player.pause()
            }
            else{
                player.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty{
            player?.pause()
        }
        else if let player = playerQueue{
            player.advanceToNextItem()
            playerVC?.refreshUI()
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty{
            player?.pause()
            player?.play()
        }
        else if let firstItem = playerQueue?.items().first{
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
        }
    }
}

extension PlaybackPresenter: PlayerViewControllerDatasource{
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.album?.name ?? currentTrack?.artists.first?.name
    }
    
    var imageUrl: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}
