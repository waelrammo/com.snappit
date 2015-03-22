//
//  MyHelpers.swift
//  SNAppIT
//
//  Created by Azat Almeev on 22.03.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import UIKit

extension UIImage {
    func rotateByOrientationFlag(orient: UIImageOrientation) -> UIImage {
        let img = self
        
        let imgRef = img.CGImage
        let width = CGImageGetWidth(imgRef)
        var height = CGImageGetHeight(imgRef)
        var transform = CGAffineTransformIdentity
        var bounds = CGRectMake(0, 0, CGFloat(width), CGFloat(height))
        let imageSize = bounds.size
        var boundHeight: CGFloat
    
        switch (orient) {
            case UIImageOrientation.Up: //EXIF = 1
                transform = CGAffineTransformIdentity
                case UIImageOrientation.Down: //EXIF = 3
                transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            
            case UIImageOrientation.Left: //EXIF = 6
                boundHeight = bounds.size.height
                bounds.size = CGSizeMake(boundHeight, bounds.size.width)
                transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width)
                transform = CGAffineTransformScale(transform, -1.0, 1.0)
                transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0);
            
            case UIImageOrientation.Right: //EXIF = 8
                boundHeight = bounds.size.height;
                bounds.size = CGSizeMake(boundHeight, bounds.size.width)
                transform = CGAffineTransformMakeTranslation(0.0,imageSize.height);
                transform = CGAffineTransformRotate(transform,3.0 * CGFloat(M_PI) / 2.0)
            
            default:
                // image is not auto-rotated by the photo picker, so whatever the user
                // sees is what they expect to get. No modification necessary
                transform = CGAffineTransformIdentity;
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()
        
        if orient == UIImageOrientation.Down || orient == UIImageOrientation.Right || orient == UIImageOrientation.Up {
            // flip the coordinate space upside down
            CGContextScaleCTM(context, 1, -1)
            CGContextTranslateCTM(context, 0, CGFloat(Int(-1) * Int(height)))
        }
        
        CGContextConcatCTM(context, transform)
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, CGFloat(width), CGFloat(height)), imgRef)
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageCopy
    }

}
