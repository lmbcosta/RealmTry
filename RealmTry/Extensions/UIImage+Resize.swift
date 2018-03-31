//
//  UIImage+Resize.swift
//  RealmTry
//
//  Created by Luis  Costa on 31/03/18.
//  Copyright © 2018 Luis  Costa. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        
        let widthRatio  = size.width  / self.size.width
        let heightRatio = size.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: self.size.width * heightRatio, height: self.size.height * heightRatio)
        }
        else {
            newSize = CGSize(width: self.size.width * widthRatio,  height: self.size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
