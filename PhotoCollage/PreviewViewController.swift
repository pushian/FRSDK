//
//  PreviewViewController.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 23/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import Social
import Messages
import MessageUI
import SVProgressHUD


class PreviewViewController: BaseViewController {
    fileprivate var processCount = 0
    fileprivate var processedSuccess = 0
    fileprivate var processedFail = 0

    fileprivate var image = UIImage()
    fileprivate var faceImages = [UIImage?]()
    fileprivate var userId: String = ""
    fileprivate var lats = [String?]()
    fileprivate var lons = [String?]()
    fileprivate var shared = [String]()
    
    fileprivate var bkView: UIImageView = {
        let t = UIImageView()
        t.backgroundColor = UIColor.phtWhiteTwo
        t.contentMode = .scaleAspectFill
        t.clipsToBounds = true
        return t
    }()
    
    fileprivate var shareLabel: UILabel! = {
        let t = UILabel()
        t.textAlignment = .center
        t.text = "Share it on:"
        t.textColor = .black
        return t
    }()
    
    fileprivate var insView: UIImageView! = {
        let t = UIImageView()
//        t.image = #imageLiteral(resourceName: "icon_instagram")
        t.FRApplyBundleImage(name: "icon-instagram")
        t.backgroundColor = .clear
        t.isUserInteractionEnabled = true
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        return t
    }()
    
    fileprivate var fbView: UIImageView! = {
        let t = UIImageView()
//        t.image = #imageLiteral(resourceName: "icon_facebook")
        t.FRApplyBundleImage(name: "icon-facebook")
//        debugPrint("fb is ok")
        t.backgroundColor = .clear
        t.isUserInteractionEnabled = true
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        return t
    }()
    
    fileprivate var twtView: UIImageView! = {
        let t = UIImageView()
//        t.image = #imageLiteral(resourceName: "icon_twitter")
        t.FRApplyBundleImage(name: "icon-twitter")
//        debugPrint("twt is ok")
        t.backgroundColor = .clear
        t.isUserInteractionEnabled = true
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        return t
    }()
    
    fileprivate var waView: UIImageView! = {
        let t = UIImageView()
//        t.image = #imageLiteral(resourceName: "icon_whatsapp")
        t.FRApplyBundleImage(name: "icon-whatsapp")
//        debugPrint("app is ok")
        t.backgroundColor = .clear
        t.isUserInteractionEnabled = true
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        return t
    }()
    
    fileprivate var mailView: UIImageView! = {
        let t = UIImageView()
//        t.image = #imageLiteral(resourceName: "icon_gmail")
        t.FRApplyBundleImage(name: "icon-gmail")
//        debugPrint("mail is ok")
        t.backgroundColor = .clear
        t.isUserInteractionEnabled = true
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        return t
    }()
    init(image: UIImage, images: [UIImage?], userId: String, lats: [String?], lons: [String?]) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
        self.faceImages = images
        self.userId = userId
        self.lats = lats
        self.lons = lons
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneHandler))
//        self.navigationItem.rightBarButtonItem = doneBtn
        
//        navigationItem.title = "Preview & Share"
        bkView.image = self.image
        view.addSubview(bkView)
        view.addSubview(shareLabel)
        view.addSubview(insView)
        let insGesture = UITapGestureRecognizer(target: self, action: #selector(insHandler))
        insView.addGestureRecognizer(insGesture)
        let fbGesture = UITapGestureRecognizer(target: self, action: #selector(fbHandler))
        fbView.addGestureRecognizer(fbGesture)
        let twtGesture = UITapGestureRecognizer(target: self, action: #selector(twtHandler))
        twtView.addGestureRecognizer(twtGesture)
        let emailGesture = UITapGestureRecognizer(target: self, action: #selector(emailHandler))
        mailView.addGestureRecognizer(emailGesture)
        
        let whatsGesture = UITapGestureRecognizer(target: self, action: #selector(waHandler))
        waView.addGestureRecognizer(whatsGesture)

        view.addSubview(fbView)
        view.addSubview(twtView)
        view.addSubview(waView)
        view.addSubview(mailView)
        
        
        setRightBtn(title: "Done")
        setTitle(title: "Preview & Share")
        
        setConstraints()
    }
    
    func setConstraints() {
        bkView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Constants.mainWidth * Constants.bkImageRatio)
        }
        shareLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(bkView.snp.bottom).offset(Scale.scaleY(y: 32))
        }
        insView.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 36))
            make.leading.equalTo(Scale.scaleX(x: 50))
            make.top.equalTo(shareLabel.snp.bottom).offset(Scale.scaleY(y: 34))
        }
        fbView.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 36))
            make.centerX.equalToSuperview()
            make.centerY.equalTo(insView)
        }
        waView.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 36))
            make.trailing.equalTo(-Scale.scaleX(x: 50))
            make.centerY.equalTo(insView)
        }
        twtView.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 36))
            make.top.equalTo(insView.snp.bottom).offset(Scale.scaleY(y: 35))
            make.leading.equalTo(insView.snp.trailing).offset(Scale.scaleX(x: 16))
        }
        mailView.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 36))
            make.trailing.equalTo(waView.snp.leading).offset(-Scale.scaleX(x: 16))
            make.centerY.equalTo(twtView)
        }
    }
    
    override func rightHandler() {
        super.rightHandler()
        
        debugPrint("right handler")
        doneHandler()
    }
    
    override func leftHandler() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    
    func doneHandler() {
        
//        _ = dismiss(animated: true, completion: nil)
//        delegate?.didTapDone()
//        self.PostDoneNotification()
        
//        let notification = Notification(name: Constants.notifications.FRdidTapDone, object: nil, userInfo: nil)
//        NotificationCenter.default.post(notification)
//        SVProgressHUD.show()
        let collageId = "\(UIDevice.current.identifierForVendor!.uuidString)+\(NSDate().timeIntervalSince1970)+\(arc4random())"
//        for (name,(age,gender)) in zip(names,zip(ages,genders)) {
        debugPrint(collageId)
        
        SVProgressHUD.show()
        processCount = 0
        processedSuccess = 0
        processedFail = 0
        
        for (face, (lat, lon)) in zip(faceImages, zip(lats, lons)) {
            if let face = face {
                processCount = processCount + 1
                var latString = lat
                var lonString = lon
                if latString == nil {
                    latString = "empty"
                }
                if lonString == nil {
                    lonString = "empty"
                }
                HttpClient.sharedInstance.sendImage(image: face, userId: userId, collageId: collageId, shared: self.shared, lat: latString!, lon: lonString!, completion: { (isSuccess) in
                    debugPrint(isSuccess)
                    if isSuccess {
                        self.processedSuccess = self.processedSuccess + 1
                    } else {
                        self.processedFail = self.processedFail + 1
                    }
                    
                })
            }
        }
        DispatchQueue.global(qos: .background).async {
            debugPrint("before the while")
            debugPrint(self.processCount)
            debugPrint(self.processedFail)
            debugPrint(self.processedSuccess)
            while self.processedFail + self.processedSuccess != self.processCount {
            }
            debugPrint("after the while")
            SVProgressHUD.dismiss()
            _ = self.dismiss(animated: true, completion: nil)
            
            let notification = Notification(name: Constants.notifications.FRdidTapDone, object: nil, userInfo: nil)
            NotificationCenter.default.post(notification)
//            if processedFail != 0 {
//                self.FRDisplayAlert(title: "Error", message: "Server Error. Please try again later", complete: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
//            }
        }

//        HttpClient.sharedInstance.sendImage(image: (self.image)!, userId: "1234567", collageId: "1234567", shared: ["facebook", "twitter"], lat: "1.111", lon: "2.222") { (isSuccess) in
//            debugPrint(isSuccess)
//            SVProgressHUD.dismiss()
//        }
    }

    func insHandler() {
//        if let vc = SLComposeViewController(forServiceType:SLServiceTypeInstagram) {
//            vc.add(image!)
//            vc.add(URL(string: "http://www.example.com/"))
//            vc.setInitialText("#thestateoffun moments")
//            self.present(vc, animated: true, completion: nil)
//        }
//        let vc = InstagramManager.sharedManager.postImageToInstagramWithCaption(imageInstagram: image!, instagramCaption: "test", view: self.view)
//        vc?.delegate = self
        shared.append("Instagram")
        let image: UIImage = self.image
        let arrayObject: [Any] = [image]
        let vc = UIActivityViewController(activityItems: arrayObject, applicationActivities: nil)
        
        self.present(vc, animated: true, completion: nil)

    }
    
    func fbHandler() {
        shared.append("Facebook")

        if let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook) {
            vc.add(image)
//            vc.add(URL(string: "http://www.example.com/"))
            vc.setInitialText("#thestateoffun moments")
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func twtHandler() {
        shared.append("Twitter")

        if let vc = SLComposeViewController(forServiceType:SLServiceTypeTwitter) {
            vc.add(image)
//            vc.add(URL(string: "http://www.example.com/"))
            vc.setInitialText("#thestateoffun moments")
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func emailHandler() {

        if( MFMailComposeViewController.canSendMail() ) {
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            //Set the subject and message of the email
            mailComposer.setSubject("#thestateoffun moments")
            mailComposer.setMessageBody("#thestateoffun moments", isHTML: false)
            let imageData: NSData = UIImagePNGRepresentation(image)! as NSData
            mailComposer.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: "testing")
            self.present(mailComposer, animated: true, completion: nil)
        }
    }
    
    func waHandler() {
        shared.append("Whatsapp")

//        var shareText: String = "#thestateoffun moments"
        let image: UIImage = self.image
        let arrayObject: [Any] = [image]
        let vc = UIActivityViewController(activityItems: arrayObject, applicationActivities: nil)
        
        self.present(vc, animated: true, completion: nil)
    }
}

extension PreviewViewController: MFMailComposeViewControllerDelegate {
//    func dids
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        shared.append("Email")
        _ = controller.dismiss(animated: true, completion: nil)
    }
}

//extension PreviewViewController: UIDocumentInteractionControllerDelegate {
//    func documentInteractionController(_ controller: UIDocumentInteractionController, didEndSendingToApplication application: String?) {
//        debugPrint(application)
//        debugPrint("didEnd")
//    }
//    func documen
//}

//extension PreviewViewController: SLComposeViewControllerde
