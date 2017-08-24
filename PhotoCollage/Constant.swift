//
//  Constant.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 22/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//


import UIKit

struct Constants {
    
    struct EndPoint {
        #if DEBUG
        static let baseURL = "https://sentosa-api.fooyo.sg/v1"
        //            static let baseURL = "http://54.169.237.216/v1"
        //            static let baseURL = "https://api.travbook.me/v1"
        #else
        static let baseURL = "https://sentosa-api.fooyo.sg/v1"
        //            static let baseURL = "https://api.travbook.me/v1"
        //            static let baseURL = "http://54.169.237.216/v1"
        #endif
    }
    
    static let imageLoadTime: Double = 0.3
    
    static let mainWidth: CGFloat = UIScreen.main.bounds.width
    static let mainHeight: CGFloat = UIScreen.main.bounds.height
    
    static let bkImageRatio: CGFloat = 384.0 / 375.0
    
    static let testImages: [UIImage] = [#imageLiteral(resourceName: "bk1"), #imageLiteral(resourceName: "bk2"), #imageLiteral(resourceName: "bk3"), #imageLiteral(resourceName: "bk4"), #imageLiteral(resourceName: "bk5")]
    
}
