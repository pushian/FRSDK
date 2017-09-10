//
//  Date-PC.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 11/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//
import UIKit
import Foundation

extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
}
