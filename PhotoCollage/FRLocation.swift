//
//  FRLocation.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 5/10/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import CoreLocation

class FRLocation: NSObject {
    static var currentLocation = FRLocation()
    
    let locationManager = CLLocationManager()
    var inSentosa = false
    var checkedLocation = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func start() {
//        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func end() {
        locationManager.stopUpdatingLocation()
    }
    
    func checkIsInSentosa() -> Bool {
        return inSentosa
    }
}


extension FRLocation: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            let locValue:CLLocationCoordinate2D = location.coordinate
            debugPrint("locations = \(locValue.latitude) \(locValue.longitude)")
            for each in Constants.sentosaRegions {
                if each.contains(locValue) {
                    inSentosa = true
                }
            }
            checkedLocation = true
        }
        
    }
}
