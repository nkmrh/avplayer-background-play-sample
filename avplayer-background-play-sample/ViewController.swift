//
//  ViewController.swift
//  avplayer-background-play-sample
//
//  Created by hajime-nakamura on 2020/12/03.
//

import AVFoundation
import UIKit

final class ViewController: UIViewController {
    @IBOutlet var playerView: PlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playerView.play()
    }
}

final class PlayerView: UIView {
    private var player: AVPlayer?

    private var playerLayer: AVPlayerLayer {
        self.layer as! AVPlayerLayer
    }

    override static var layerClass: AnyClass {
        AVPlayerLayer.self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.addNotificationObserver()
        self.setupPlayer()
    }

    func play() {
        self.player?.play()
    }

    private func setupPlayer() {
        guard let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear1/prog_index.m3u8")
        else { return }
        self.player = AVPlayer(url: url)
        self.playerLayer.player = self.player
    }
}

extension PlayerView {
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground(_:)),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground(_:)),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }

    @objc private func willEnterForeground(_ notification: Notification) {
        self.playerLayer.player = self.player
    }

    @objc private func didEnterBackground(_ notification: Notification) {
        self.playerLayer.player = nil
    }
}
