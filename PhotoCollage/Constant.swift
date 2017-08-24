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
    
    static let testImages: [UIImage] = [UIImage.getBundleImage(name: "bk1"), UIImage.getBundleImage(name: "bk2"), UIImage.getBundleImage(name: "bk3"), UIImage.getBundleImage(name: "bk4"), UIImage.getBundleImage(name: "bk5")]
    
    struct notifications {
        static let FRdisplayAlert = Notification.Name("FR_display_alert")
        static let FRdidTapDone = Notification.Name("FR_did_tap_done")
    }
}
