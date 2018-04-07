//
//  ImageResize.swift
//  Thesis
//
//  Created by Tudor Stanila on 07/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import UIKit
class ImageResizeHelper{
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
