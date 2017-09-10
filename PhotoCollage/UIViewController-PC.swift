//
//  UIViewController-PC.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 23/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import SVProgressHUD

extension UIViewController {
    func FRDisplayAlert(title: String, message: String, complete: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let complete = complete {
                complete()
            }
        }))
        present(alertController, animated: true, completion: nil)
        return
    }
}


extension UIViewController: HttpClientDelegte {
    func alertMessage(title: String, message: String) {
        debugPrint("~~~~~~~~~~")
        debugPrint(message)
        FRDisplayAlert(title: title, message: message, complete: nil)
    }
}
