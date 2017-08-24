//
//  PreviewViewController.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 23/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class PreviewViewController: BaseViewController {
    fileprivate var image: UIImage?
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
        t.applyBundleImage(name: "icon-instagram")
        t.backgroundColor = .clear
        t.isUserInteractionEnabled = true
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        return t
    }()
    
    fileprivate var fbView: UIImageView! = {
        let t = UIImageView()
//        t.image = #imageLiteral(resourceName: "icon_facebook")
        t.applyBundleImage(name: "icon-facebook")
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
        t.applyBundleImage(name: "icon-twitter")
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
        t.applyBundleImage(name: "icon-whatsapp")
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
        t.applyBundleImage(name: "icon-gmail")
//        debugPrint("mail is ok")
        t.backgroundColor = .clear
        t.isUserInteractionEnabled = true
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        return t
    }()
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneHandler))
        self.navigationItem.rightBarButtonItem = doneBtn
        
        navigationItem.title = "Preview & Share"
        bkView.image = self.image
        view.addSubview(bkView)
        view.addSubview(shareLabel)
        view.addSubview(insView)
        view.addSubview(fbView)
        view.addSubview(twtView)
        view.addSubview(waView)
        view.addSubview(mailView)
        setConstraints()
    }
    
    func setConstraints() {
        bkView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
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
    
    func doneHandler() {
//        _ = dismiss(animated: true, completion: nil)
//        delegate?.didTapDone()
//        self.PostDoneNotification()
        
        let notification = Notification(name: Constants.notifications.FRdidTapDone, object: nil, userInfo: nil)
        NotificationCenter.default.post(notification)
    }

}
