//
//  HTTPClient.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 8/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

protocol HttpClientDelegte: class {
    func alertMessage(title: String, message: String)
}

class HttpClient: NSObject {
    static let sharedInstance = HttpClient()
    
    weak var delegate: HttpClientDelegte?
    //MARK: - Settings
    func sendImage(image: UIImage, userId: String, collageId: String, shared: [String], lat: String, lon: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let url = "https://sandbox.facerecog.io/"
        debugPrint(url)
        
        var sup = "user_id: \(userId), collage_id: \(collageId), shared_on: ["
        if shared.count == 0 {
            sup = sup + "], "
        } else {
            for count in 0..<shared.count {
                let each = shared[count]
                if count == shared.count - 1 {
                    sup = sup + each + "], "
                } else {
                    sup = sup + each + ","
                }
            }
        }
        sup = sup + "location: \(lat), \(lon)"
        debugPrint(sup)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                let newImage = image.resizeImage()
                let data = UIImageJPEGRepresentation(newImage, 1)!
                multipartFormData.append(data, withName: "imgFile", fileName: "avatar.jpg", mimeType: "image/jpg")
                multipartFormData.append(sup.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "supplementaryData")
                multipartFormData.append("facerecog".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "apiKey")
        },
            to: url,
            method: .post,
//            headers: User.currentUser.headers,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
//                        debugPrint(response)
                        let code = (response.response?.statusCode) ?? 500
                        if code >= 200 && code <= 299 {
                            completion(true)
                            return
                        } else {
                            self.delegate?.alertMessage(title: "Error", message: "Server error.\nPlease try again later.")
                        }
                        completion(false)
                    }//upload.responseJSON
                    
                case .failure(let encodingError):
                    self.delegate?.alertMessage(title: "Error", message: "Server error.\nPlease try again later.")
                    completion(false)
                }//switch
        }
        )
        
    }
}
