//
//  UIViewController+.swift
//  SleepSound
//
//  Created by mac on 4/22/19.
//  Copyright © 2019 mac. All rights reserved.
//

extension UIViewController {
    func logDeinit() {
        print(String(describing: type(of: self)) + " deinit")
    }
    
    func showError(message: String?, completion: (() -> Void)? = nil) {
        let ac = UIAlertController(title: "Error",
                                   message: message,
                                   preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        }
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
}
