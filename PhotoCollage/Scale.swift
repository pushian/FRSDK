//
//  Scale.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 21/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class Scale: AnyObject {
    class func roundToPlaces(value:CGFloat, places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return round(value * divisor) / divisor
    }
    
    class func scaleX(x: CGFloat) -> CGFloat {
        let iphone4 = CGRect(x: 0, y: 0, width: 320, height: 480)
        let iphone5 = CGRect(x: 0, y: 0, width: 320, height: 568)
        let iphone6 = CGRect(x: 0, y: 0, width: 375, height: 667)
        let iphone6Plus = CGRect(x: 0, y: 0, width: 414, height: 736)
        let my = UIScreen.main.bounds
        if my == iphone6 {
            return x
        } else if my == iphone6Plus {
            return x * roundToPlaces(value: (414.0 / 375.0), places: 0)
        } else if my == iphone5 {
            return x * roundToPlaces(value: (320.0 / 375.0), places: 0)
        } else if my == iphone4 {
            return x * roundToPlaces(value: (320.0 / 375.0), places: 0)
        }
        return x
    }
    
    class func scaleY(y: CGFloat) -> CGFloat {
        let iphone4 = CGRect(x: 0, y: 0, width: 320, height: 480)
        let iphone5 = CGRect(x: 0, y: 0, width: 320, height: 568)
        let iphone6 = CGRect(x: 0, y: 0, width: 375, height: 667)
        let iphone6Plus = CGRect(x: 0, y: 0, width: 414, height: 736)
        let my = UIScreen.main.bounds
        if my == iphone6 {
            return y
        } else if my == iphone6Plus {
            return y * roundToPlaces(value: (736.0 / 667.0), places: 0)
        } else if my == iphone5 {
            return y * roundToPlaces(value: (568.0 / 667.0), places: 0)
        } else if my == iphone4 {
            return y * roundToPlaces(value: (480.0 / 667.0), places: 0)
        }
        return y
    }
}
