//
//  Constant.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 22/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//


import UIKit
import CoreLocation

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
    static let regionOne = CLCircularRegion(center: CLLocationCoordinate2D.init(latitude: 1.246664, longitude: 103.832981), radius: 1000, identifier: "regionOne")
    static let regionTwo = CLCircularRegion(center: CLLocationCoordinate2D.init(latitude: 1.246506, longitude: 103.842322), radius: 1000, identifier: "regionTwo")
    static let regionThree = CLCircularRegion(center: CLLocationCoordinate2D.init(latitude: 1.254076, longitude: 103.820066), radius: 1000, identifier: "regionThree")
    static let regionFour = CLCircularRegion(center: CLLocationCoordinate2D.init(latitude: 1.257684, longitude: 103.811023), radius: 700, identifier: "regionFour")
    static let regionFive = CLCircularRegion(center: CLLocationCoordinate2D.init(latitude: 1.364704, longitude: 103.764176), radius: 700, identifier: "regionFive")
    static let regionSix = CLCircularRegion(center: CLLocationCoordinate2D.init(latitude: 1.298171, longitude: 103.786036), radius: 700, identifier: "regionSix")
    

//    static let sentosaRegions = [regionOne, regionTwo, regionThree, regionFour]
    static let sentosaRegions = [regionOne, regionTwo, regionThree, regionFour, regionFive, regionSix]

    static let imageLoadTime: Double = 0.3
    
    static let mainWidth: CGFloat = UIScreen.main.bounds.width
    static let mainHeight: CGFloat = UIScreen.main.bounds.height
    
    static let bkImageRatio: CGFloat = 384.0 / 375.0
    
    static let testImages: [UIImage] = [UIImage.FRGetBundleImage(name: "bk1"), UIImage.FRGetBundleImage(name: "bk2"), UIImage.FRGetBundleImage(name: "bk4"), UIImage.FRGetBundleImage(name: "bk5")]
    
    struct notifications {
        static let FRdisplayAlert = Notification.Name("FR_display_alert")
        static let FRdidTapDone = Notification.Name("FR_did_tap_done")
    }
}
