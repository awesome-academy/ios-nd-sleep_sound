//
//  UIAlertController+.swift
//  SleepSound
//
//  Created by mac on 5/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

extension UIAlertController {
    static func showDefault(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alert.addAction(alertAction)
        UIApplication.topViewController()?.present(alert, animated: true) { }
    }
}
