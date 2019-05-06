//
//  AVPlayer+.swift
//  SleepSound
//
//  Created by mac on 5/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

extension AVPlayer {
    func configure() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: self.currentItem,
                                               queue: .main) { [weak self] _ in
                                                self?.seek(to: CMTime.zero)
                                                self?.play()
        }
    }
}
