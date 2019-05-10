//
//  Timers.swift
//  SleepSound
//
//  Created by mac on 5/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

final class Timers: NSObject {
    static let shared: Timers = {
        let instance = Timers()
        return instance
    }()
    private var timer: Timer?
    
    func starTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            print("tick")
            NotificationCenter.default.post(name: NSNotification.Name("configureTimer"), object: true)
            if let date = UserDefaults.standard.dateForKey("fireDate") {
                let leftTime = Int(date.timeIntervalSince(Date()))
                if leftTime <= 0 {
                    self.stopTimer()
                    NotificationCenter.default.post(name: NSNotification.Name("stopAndClearAudio"), object: true)
                }
            }
        })
    }
    
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
        }
        timer = nil
    }
}
