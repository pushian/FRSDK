//
//  NSObject.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 23/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func FRGetBundleImage(name: String, replaceColor: UIColor? = nil) -> UIImage  {
        if let bundlePath: String = Bundle.main.path(forResource: "FRPhotoCollageSDK", ofType: "bundle") {
            if let bundle = Bundle(path: bundlePath) {
                let resource: String = bundle.path(forResource: name, ofType: "png")!
                if let color = replaceColor {
                    return (UIImage(contentsOfFile: resource)?.FRImageByReplacingContentWithColor(color: color))!
                } else {
                    return UIImage(contentsOfFile: resource)!
                }
            }
        }
        return UIImage()
    }
    
    convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
    
    func FRImageByReplacingContentWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: 0, y: self.size.height)
        context!.scaleBy(x: 1.0, y: -1.0);
        context!.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context!.clip(to: rect, mask: self.cgImage!)
        context!.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func resizeImage() -> UIImage {
//        let width = self.size.width
//        let height = self.size.height
//        debugPrint(width)
//        let radio = height / width
//        let newSize = CGSize(width: 1024, height: 1024 * radio)
//        let newImage = self.af_imageAspectScaled(toFill: newSize)
//        var data = UIImageJPEGRepresentation(newImage, 1.0)!
        
        var first = false
        var imageData = UIImageJPEGRepresentation(self, 1.0)!
        var factor: CGFloat = 1.0
        var maxFactor: CGFloat = 1.0
        var minFactor: CGFloat = 0.0;  // or use 0.8 or whatever you want
        let size = self.size;
        var currentSize  = size;
        var currentImage = self;
        debugPrint("=====================")
        debugPrint(imageData.count / 1024)
        if imageData.count >= (1024 * 2048) {
            while (imageData.count >= (1024 * 2048) || imageData.count <= (1024 * 2000))
            {
                if first {
                    factor = 0.5
                    first = false
                } else {
                    if imageData.count >= (1024 * 2048) {
                        maxFactor = factor
                        factor = (minFactor + maxFactor) / 2
                    } else {
                        minFactor = factor
                        factor = (minFactor + maxFactor) / 2
                    }
                }
                debugPrint(factor)
                currentSize = CGSize(width: round(size.width * factor), height: round(size.height * factor))
                currentImage = self.af_imageAspectScaled(toFill: currentSize)
                imageData = UIImageJPEGRepresentation(currentImage, 1.0)!
                debugPrint(imageData.count / 1024)
            }
        }

        return currentImage
    }
    
    // 2048K
    
//    func resizeImage() -> UIImage {
//        //        var first = true
//        return currentImage
//    }
}
