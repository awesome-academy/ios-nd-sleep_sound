//
//  TimersViewController.swift
//  SleepSound
//
//  Created by mac on 5/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

final class TimersViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var deleteCurrentTimeButton: UIButton!
    
    // MARK: - Properties
    private var timer: Timer?
    let fillColor = UIColor(red: 180 / 255, green: 210 / 255, blue: 126 / 255, alpha: 1)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(configureTimer),
                                               name: NSNotification.Name("configureTimer"),
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - IBAction
    @IBAction func setTimerTapped(_ sender: Any) {
        let date = datePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        var fireDate = Date()
        if let hour = components.hour, let minute = components.minute {
            fireDate = Date().addingTimeInterval(Double(hour * 3_600 + minute * 60 + 1))
        }
        UserDefaults.standard.setDate(fireDate, forKey: "fireDate")
        UserDefaults.standard.synchronize()
        Timers.shared.starTimer()
        self.dismiss(animated: true, completion: { })
    }
    
    @IBAction func deleteCurrentTimeButtonTapped(_ sender: Any) {
        Timers.shared.stopTimer()
        currentTimeLabel.isHidden = true
        deleteCurrentTimeButton.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name("stopAndClearAudio"), object: true)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: { })
    }
    
    // MARK: - Methods
    @objc
    func configureTimer() {
        if let date = UserDefaults.standard.dateForKey("fireDate") {
            let leftTime = Int(date.timeIntervalSince(Date()))
            let hour = leftTime / 3_600
            let minute = (leftTime - hour * 3_600) / 60
            let second = leftTime - hour * 3_600 - minute * 60
            let setTime = "\(String(format: "%02d : %02d : %02d", hour, minute, second))"
            deleteCurrentTimeButton.isHidden = false
            currentTimeLabel.isHidden = false
            currentTimeLabel.attributedText = NSAttributedString(string: "  " + "\(setTime)" + "       ")
            if hour == 0 && minute == 0 && second <= 0 {
                currentTimeLabel.isHidden = true
                deleteCurrentTimeButton.isHidden = true
            }
        }
    }
    
    func configView() {
        currentTimeLabel.isHidden = true
        deleteCurrentTimeButton.isHidden = true
        datePicker.do {
            $0.setValue(fillColor, forKey: "textColor")
            $0.backgroundColor = UIColor(red: 27 / 255, green: 82 / 255, blue: 112 / 255, alpha: 1)
        }
    }
}
