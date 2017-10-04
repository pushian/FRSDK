//
//  NSObject-PC.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 24/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//


import UIKit
import CoreLocation


func PostDoneNotification() {
    let notification = Notification(name: Constants.notifications.FRdidTapDone, object: nil, userInfo: nil)
    NotificationCenter.default.post(notification)
}

func PostAlertNotification(title: String, message: String) {
    let info = [
        "title": title,
        "message": message
    ]
    let notification = Notification(name: Constants.notifications.FRdisplayAlert, object: info, userInfo: nil)
    NotificationCenter.default.post(notification)
}

public func FRSDKStartMonitoring(completion: @escaping (_ isSuccess: Bool) -> Void) {
//    let location = FRLocation()
    let haveData = FRUser.awakeCurrentUserFromDefaults()
    debugPrint("i am checking whether do i have data: \(haveData)")
    debugPrint(FRUser.currentUser.enteringTime)
    FRLocation.currentLocation.start()
//    while !FRLocation.currentLocation.inSentosa {
//        
//    }
    DispatchQueue.global(qos: .background).async {
//        self.getPhoto()
        while !FRLocation.currentLocation.checkedLocation {
//            debugPrint()
//            debugPrint(FRLocation.currentLocation.inSentosa)
        }
        FRLocation.currentLocation.end()
        
        if FRLocation.currentLocation.inSentosa {
            if let time = FRUser.currentUser.enteringTime {
                let format = DateFormatter()
                let str = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
                format.dateFormat = str
                let date = format.date(from: time)!
                let diff = Date().timeIntervalSince(date)
                let min = diff / Double(60)
                debugPrint(format.string(from: Date()))
                debugPrint("the difference is \(min) mins")
                if min > 90 {
                    completion(true)
                    FRUser.currentUser.enteringTime = nil
                    FRUser.currentUser.saveToDefaults()
                } else {
                    completion(false)
                }
            } else {
                let str = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
                let format = DateFormatter()
                format.dateFormat = str
                let dateStr = format.string(from: Date())
                FRUser.currentUser.enteringTime = dateStr
                FRUser.currentUser.saveToDefaults()
                completion(false)
            }
        } else {
            if let time = FRUser.currentUser.enteringTime {
                completion(true)
                FRUser.currentUser.enteringTime = nil
                FRUser.currentUser.saveToDefaults()
            } else {
                completion(false)
            }
        }
    }
}



