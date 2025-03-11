//
//  PodcastPlayerModel.swift
//  Yasir
//
//  Created by Yomna Eisa on 11/03/2025.
//

import AVKit

class PodcastPlayerModel {
    private var player: AVPlayer
    private var timeObserverToken: Any?

    var onTimeUpdated: ((CMTime) -> Void)?

    init(url: URL) {
        player = AVPlayer(url: url)
    }

    func playfunc() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func seek(to time: CMTime) {
        player.seek(to: time)
    }

    func setPlaybackRate(_ rate: Float) {
        player.rate = rate
    }

    func setVolume(_ volume: Float) {
        player.volume = volume
    }

    var currentTime: CMTime {
        player.currentTime()
    }

    var duration: CMTime? {
        player.currentItem?.duration
    }

    func startObservingTime() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.onTimeUpdated?(time)
        }
    }

    func stopObservingTime() {
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
        }
    }

    deinit {
        stopObservingTime()
    }
}
