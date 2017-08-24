//
//  NSObject-PC.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 24/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//


import Foundation
import UIKit

func PostDoneNotification() {
    let notification = Notification(name: Constants.notifications.didTapDone, object: nil, userInfo: nil)
    NotificationCenter.default.post(notification)
}
