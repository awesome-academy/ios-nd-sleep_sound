//
//  UIViewController+.swift
//  SleepSound
//
//  Created by mac on 4/22/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

extension UIViewController {
    func logDeinit() {
        print(String(describing: type(of: self)) + " deinit")
    }
}
