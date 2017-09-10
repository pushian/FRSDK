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
        let width = self.size.width
        let height = self.size.height
        debugPrint(width)
        let radio = height / width
        let newSize = CGSize(width: 1024, height: 1024 * radio)
        let newImage = self.af_imageAspectScaled(toFill: newSize)
//        var data = UIImageJPEGRepresentation(newImage, 1.0)
        return newImage
    }

}
