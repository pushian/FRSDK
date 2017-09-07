////
////  InstagramManager.swift
////  TravBook
////
////  Created by Yangfan Liu on 26/7/16.
////  Copyright © 2016 Yangfan Liu. All rights reserved.
////
//
//import UIKit
//import Foundation
//
//class InstagramManager: NSObject, UIDocumentInteractionControllerDelegate {
//    
//    fileprivate let kInstagramURL = "instagram://app"
//    fileprivate let kUTI = "com.instagram.exclusivegram"
//    fileprivate let kfileNameExtension = "instagram.igo"
//    fileprivate let kAlertViewTitle = "Error"
//    fileprivate let kAlertViewMessage = "Please install the Instagram application"
//    
//    var documentInteractionController = UIDocumentInteractionController()
//    
//    // singleton manager
//    class var sharedManager: InstagramManager {
//        struct Singleton {
//            static let instance = InstagramManager()
//        }
//        return Singleton.instance
//    }
//    
//    func postImageToInstagramWithCaption(_ imageInstagram: UIImage, instagramCaption: String, view: UIView) {
//        // called to post image with caption to the instagram application
//        let instagramURL = URL(string: kInstagramURL)
//        debugPrint("i am checking")
//        debugPrint(instagramURL)
//        if UIApplication.shared.canOpenURL(instagramURL!) {
//            let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(kfileNameExtension)
//            try? UIImageJPEGRepresentation(imageInstagram, 1.0)!.write(to: URL(fileURLWithPath: jpgPath), options: [.atomic])
//            let rect = CGRect(x: 0,y: 0,width: 612,height: 612)
//            let fileURL = URL(fileURLWithPath: jpgPath)
//            documentInteractionController.url = fileURL
//            documentInteractionController.delegate = self
//            documentInteractionController.uti = kUTI
//            
//            // adding caption for the image
////            documentInteractionController.annotation = ["InstagramCaption": instagramCaption]
//            documentInteractionController.presentOpenInMenu(from: rect, in: view, animated: true)
//        } else {
//            // alert displayed when the instagram application is not available in the device
//            UIAlertView(title: kAlertViewTitle, message: kAlertViewMessage, delegate:nil, cancelButtonTitle:"Ok").show()
//        }
//    }
//    
//}

import UIKit
import Foundation

class InstagramManager: NSObject, UIDocumentInteractionControllerDelegate {
    
    private let kInstagramURL = "instagram://app"
    private let kUTI = "com.instagram.exclusivegram"
    private let kfileNameExtension = "instagram.igo"
    private let kAlertViewTitle = "Error"
    private let kAlertViewMessage = "Please install the Instagram application"
    
    var documentInteractionController = UIDocumentInteractionController()
    
    // singleton manager
    class var sharedManager: InstagramManager {
        struct Singleton {
            static let instance = InstagramManager()
        }
        return Singleton.instance
    }
    
    func postImageToInstagramWithCaption(imageInstagram: UIImage, instagramCaption: String, view: UIView) -> UIDocumentInteractionController? {
        // called to post image with caption to the instagram application
        
        let instagramURL = NSURL(string: kInstagramURL)
        
        if UIApplication.shared.canOpenURL(instagramURL! as URL) {
            
            let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(kfileNameExtension)
            
            do {
                try UIImageJPEGRepresentation(imageInstagram, 1.0)?.write(to: URL(fileURLWithPath: jpgPath), options: .atomic)
                
            } catch {
                
                print(error)
            }
            
            let rect = CGRect(x: 0, y: 0, width: 612, height: 612)
            let fileURL = NSURL.fileURL(withPath: jpgPath)
            documentInteractionController.url = fileURL
            documentInteractionController.delegate = self
            documentInteractionController.uti = kUTI
            
            // adding caption for the image
            documentInteractionController.annotation = ["InstagramCaption": instagramCaption]
            documentInteractionController.presentOpenInMenu(from: rect, in: view, animated: true)
//            documentInteractionController.de
            return documentInteractionController
        } else {
            
            /// display some message about how it didn't work
            /// Like: UIAlertController(title: kAlertViewTitle, message: kAlertViewMessage, preferredStyle: .alert)
            return nil
        }
    }
}
