//
//  FRUser.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 5/10/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class FRUser: NSObject, NSCoding {
    
    static var currentUser = FRUser()
    var enteringTime: String?
    var havePoped: Bool?
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    
    
    
    override init() {
        super.init()
    }
    
    class func awakeCurrentUserFromDefaults() -> Bool {
        let ud = UserDefaults.standard
        if let data = ud.object(forKey: "current_fr_user") as? NSData {
            let u : FRUser = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! FRUser
            currentUser = u
            return true
        }
        return false
    }
    
    func saveToDefaults() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        let ud = UserDefaults.standard
        ud.set(data, forKey: "current_fr_user")
        ud.synchronize()
    }
    
    class func destoryCurrentUser() {
        let ud = UserDefaults.standard
        ud.removeObject(forKey: "current_fr_user")
        ud.synchronize()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.enteringTime, forKey: "enteringTime")
        aCoder.encode(self.havePoped, forKey: "havePoped")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        enteringTime = aDecoder.decodeObject(forKey: "enteringTime") as? String
        havePoped = aDecoder.decodeObject(forKey: "havePoped") as? Bool
    }
}
