//
//  UIApplication+.swift
//  SleepSound
//
//  Created by mac on 5/2/19.
//  Copyright © 2019 mac. All rights reserved.
//

extension UIApplication {
    class func topViewController() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}
