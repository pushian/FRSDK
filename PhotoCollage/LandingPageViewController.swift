//
//  LandingPageViewController.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 21/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import SnapKit
public protocol FRPhotoCollageCreateDelegate: class {
    func didTapCancel()
    func didTapDone()
}

public class FRPhotoCollageCreate: UIViewController {

    public weak var delegate: FRPhotoCollageCreateDelegate?
    
    fileprivate var titleLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
        t.textColor = UIColor.black
        t.text = "#thestateoffun moments"
        t.textAlignment = .center
        return t
    }()
    fileprivate var coverImage: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
//        t.image = #imageLiteral(resourceName: "splash-image")
        t.applyBundleImage(name: "splash-image")
        return t
    }()
    fileprivate var infoLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 24))
        t.textColor = UIColor.black
        t.text = "Create your own unique collage with the photos you took in Sentosa!"
        t.textAlignment = .center
        t.numberOfLines = 0
        return t
    }()
    
    fileprivate var okBtn: UIButton! = {
        let t = UIButton()
        t.setTitle("OK  ", for: .normal)
        let image = UIImage.getBundleImage(name: "rightArrow")
        t.setImage(image, for: .normal)
        t.setTitleColor(.white, for: .normal)
        t.titleLabel?.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 12))
        t.backgroundColor = UIColor.phtMidGreen
        t.clipsToBounds = true
        t.layer.cornerRadius = Scale.scaleY(y: 40) / 2
        return t
    }()
    fileprivate var cancelLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.textColor = UIColor.phtAzure
        t.text = "No, I don’t want to participate"
        t.textAlignment = .center
        return t
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(previewDoneHandler), name: Constants.notifications.FRdidTapDone, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(displayAlert(notification:)), name: Constants.notifications.FRdisplayAlert, object: nil)

        view.addSubview(titleLabel)
        view.addSubview(coverImage)
        view.addSubview(infoLabel)
        view.addSubview(okBtn)
        okBtn.addTarget(self, action: #selector(okHandler), for: .touchUpInside)
        view.addSubview(cancelLabel)
        
        cancelLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(cancelHandler))
        cancelLabel.addGestureRecognizer(gesture)
        setConstraints()
        flipBtn()
        checkBundle()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    func flipBtn() {
        okBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        okBtn.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        okBtn.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    func setConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(Scale.scaleY(y: 29))
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        coverImage.snp.makeConstraints { (make) in
            make.height.equalTo(Scale.scaleY(y: 186))
            make.width.equalTo(Scale.scaleY(y: 231))
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(Scale.scaleY(y: 86))
        }
        infoLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 20))
            make.trailing.equalTo(Scale.scaleX(x: -20))
            make.top.equalTo(coverImage.snp.bottom).offset(Scale.scaleY(y: 43))
        }
        okBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 20))
            make.trailing.equalTo(Scale.scaleX(x: -20))
            make.centerX.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 40))
            make.bottom.equalTo(cancelLabel.snp.top).offset(Scale.scaleY(y: -20))
        }
        cancelLabel.snp.makeConstraints { (make) in
            make.height.equalTo(Scale.scaleY(y: 15))
            make.bottom.equalTo(Scale.scaleY(y: -20))
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    func cancelHandler() {
//        self.dismiss(animated: t rue, completion: nil)
        delegate?.didTapCancel()
    }
    
    func okHandler() {
        let vc = MainViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func previewDoneHandler() {
        delegate?.didTapDone()
    }
    
    func displayAlert(notification: Notification) {
        if let info = notification.object as? [String: String] {
            let title = info["title"] ?? ""
            let msg = info["message"] ?? ""
            displayAlert(title: title, message: msg, complete: nil)
        }
    }
    func checkBundle() {
        if let bundlePath: String = Bundle.main.path(forResource: "FRPhotoCollageSDK", ofType: "bundle") {
            if let _ = Bundle(path: bundlePath) {
                return
            }
        }
        let info = [
            "title": "Error",
            "message": "The \"FRPhotoCollageSDK.bundle\" file is missing."
        ]
        let notification = Notification(name: Constants.notifications.FRdisplayAlert, object: info, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
}
