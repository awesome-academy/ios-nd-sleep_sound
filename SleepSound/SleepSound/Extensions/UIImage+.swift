//
//  UIImage+.swift
//  SleepSound
//
//  Created by mac on 4/23/19.
//  Copyright © 2019 mac. All rights reserved.
//

extension UIImage {
    func imageWithColor(newColor: UIColor?) -> UIImage? {
        guard let newColor = newColor else {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.setBlendMode(.normal)
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            if let cgImage = cgImage {
                context.clip(to: rect, mask: cgImage)
            }
            newColor.setFill()
            context.fill(rect)
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage
    }
}
