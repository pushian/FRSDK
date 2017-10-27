//
//  PC_font.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 21/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

extension UIFont {
    class func DefaultRegularWithSize(size: CGFloat) -> UIFont {
//        return UIFont.systemFont(ofSize: size)
        return UIFont(name: "Quicksand-Regular", size: size)!

    }
    class func DefaultSemiBoldWithSize(size: CGFloat) -> UIFont {
//        return UIFont.systemFont(ofSize: size, weight: UIFontWeightSemibold)
        return UIFont(name: "Quicksand-Medium", size: size)!
    }
    class func DefaultBoldWithSize(size: CGFloat) -> UIFont {
//        return UIFont.systemFont(ofSize: size, weight: UIFontWeightBold)
        return UIFont(name: "Quicksand-Bold", size: size)!
    }
}
