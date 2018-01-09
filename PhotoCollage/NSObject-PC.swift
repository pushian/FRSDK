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
    if FRUser.currentUser.havePoped == true {
        debugPrint("have be poped up before so will be blocked here")

        return
    }
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
                format.locale = Locale.init(identifier: "en_SG")
                format.timeZone = TimeZone.init(identifier: "Asia/Singapore")

                let date = format.date(from: time)!
                
                let calendar = Calendar.current
                let recordedDay = calendar.component(.day, from: date)
                let currentDay = calendar.component(.day, from: Date())
                debugPrint(recordedDay)
                debugPrint(currentDay)
                if currentDay != recordedDay {
                    let format = DateFormatter()
                    let str = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
                    format.dateFormat = str
                    format.locale = Locale.init(identifier: "en_SG")
                    format.timeZone = TimeZone.init(identifier: "Asia/Singapore")
                    let dateStr = format.string(from: Date())
                    debugPrint("RE-recording the entry time")
                    FRUser.currentUser.enteringTime = dateStr
                    FRUser.currentUser.saveToDefaults()
                    completion(false)
                    return
                }

                let diff = Date().timeIntervalSince(date)
                let min = diff / Double(60)
                debugPrint(format.string(from: Date()))
                debugPrint("the difference is \(min) mins")
                
                if min > 120 {
                    completion(true)
                    FRUser.currentUser.havePoped = true
                    FRUser.currentUser.enteringTime = nil
                    FRUser.currentUser.saveToDefaults()
                    return
                } else {
                    completion(false)
                    return
                }
            } else {
                let format = DateFormatter()
                let str = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
                format.dateFormat = str
                format.locale = Locale.init(identifier: "en_SG")
                format.timeZone = TimeZone.init(identifier: "Asia/Singapore")
                let dateStr = format.string(from: Date())
                debugPrint("recording the entry time")
                FRUser.currentUser.enteringTime = dateStr
                FRUser.currentUser.saveToDefaults()
                completion(false)
                return
            }
        } else {
            if let time = FRUser.currentUser.enteringTime {
                completion(true)
                FRUser.currentUser.havePoped = true
                FRUser.currentUser.enteringTime = nil
                FRUser.currentUser.saveToDefaults()
                return
            } else {
                completion(false)
                return
            }
        }
    }
}



