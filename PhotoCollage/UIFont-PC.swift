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
        return UIFont.systemFont(ofSize: size)
    }
    class func DefaultSemiBoldWithSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFontWeightSemibold)
    }
    class func DefaultBoldWithSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFontWeightBold)
    }
}
