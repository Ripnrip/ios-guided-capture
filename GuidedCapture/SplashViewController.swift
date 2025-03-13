//
//  SplashViewController.swift
//  EtherealDimension
//
//  Created by Gurinder Singh on 8/1/24.
//

import UIKit
import AVKit
import SwiftUI

class SplashViewController: UIViewController {
    private var player: AVPlayer?
    private var playerViewController: AVPlayerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayer()
    }

    private func setupVideoPlayer() {
        guard let path = Bundle.main.path(forResource: "EtherealDimensionsSplash", ofType: "mp4") else {
            transitionToMainViewController()
            return
        }

        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
        playerViewController?.videoGravity = .resizeAspectFill
        playerViewController?.showsPlaybackControls = false
        playerViewController?.view.frame = self.view.bounds

        if let playerVC = playerViewController {
            addChild(playerVC)
            view.addSubview(playerVC.view)
            playerVC.didMove(toParent: self)
        }

        // Play the video
        player?.play()

        // Add notification observer to transition after video ends
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)

        // Alternatively, set a timer to transition after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.transitionToMainViewController()
        }
    }

    @objc private func videoDidFinish() {
        transitionToMainViewController()
    }

    @MainActor
    private func transitionToMainViewController() {
        removeVideoPlaybackNotificationListener()
        
        DispatchQueue.main.async {
            let contentView = ContentView()
            let hostingController = UIHostingController(rootView: contentView)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = hostingController
                window.makeKeyAndVisible()
                
                let options: UIView.AnimationOptions = .transitionCrossDissolve
                UIView.transition(with: window, duration: 0.5, options: options, animations: nil, completion: nil)
            }
        }
    }
    
    private func removeVideoPlaybackNotificationListener() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }

    deinit {
        removeVideoPlaybackNotificationListener()
    }
}
