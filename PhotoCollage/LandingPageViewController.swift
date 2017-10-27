//
//  LandingPageViewController.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 21/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation

public protocol FRPhotoCollageCreateDelegate: class {
    func FRDidTapCancel()
    func FRDidTapDone()
}

public class FRPhotoCollageCreate: UIViewController {

    public weak var delegate: FRPhotoCollageCreateDelegate?
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var userId = ""
    fileprivate var titleLabel: UILabel! = {
        let t = UILabel()
        t.textColor = UIColor.black
        t.text = "#thestateoffun moments"
        t.textAlignment = .center
        return t
    }()
    fileprivate var coverImage: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
//        t.image = #imageLiteral(resourceName: "splash-image")
        t.FRApplyBundleImage(name: "splash-image")
        return t
    }()
    fileprivate var infoLabel: UILabel! = {
        let t = UILabel()
        t.textColor = UIColor.black
        t.text = "Create your own unique collage with the photos you took in Sentosa!"
        t.textAlignment = .center
        t.numberOfLines = 0
        return t
    }()
    
    fileprivate var okBtn: UIButton! = {
        let t = UIButton()
        t.setTitle("OK  ", for: .normal)
        let image = UIImage.FRGetBundleImage(name: "rightArrow")
        t.setImage(image, for: .normal)
        t.setTitleColor(.white, for: .normal)
        t.backgroundColor = UIColor.phtMidGreen
        t.clipsToBounds = true
        t.layer.cornerRadius = Scale.scaleY(y: 40) / 2
        return t
    }()
    fileprivate var cancelLabel: UILabel! = {
        let t = UILabel()
        t.textColor = UIColor.phtAzure
        t.text = "Back"
        t.textAlignment = .center
        return t
    }()
    
    public init(uniqueId: String) {
        super.init(nibName: nil, bundle: nil)
        self.userId = uniqueId
        FontBlaster.blast() { (fonts) in
            debugPrint("i am printing fonts")
            print(fonts) // fonts is an array of Strings containing font names
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.delegate = self

        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(previewDoneHandler), name: Constants.notifications.FRdidTapDone, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(displayAlert(notification:)), name: Constants.notifications.FRdisplayAlert, object: nil)

        view.addSubview(titleLabel)
        titleLabel.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
        view.addSubview(coverImage)
        view.addSubview(infoLabel)
        infoLabel.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 24))
        view.addSubview(okBtn)
        okBtn.titleLabel?.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 12))
        okBtn.addTarget(self, action: #selector(okHandler), for: .touchUpInside)
        view.addSubview(cancelLabel)
        cancelLabel.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))

        cancelLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(cancelHandler))
        cancelLabel.addGestureRecognizer(gesture)
        setConstraints()
        flipBtn()
        checkBundle()
        
        checkLocation()
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
    
    func checkLocation() {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                self.FRDisplayAlert(title: "Reminder", message: "The permission to access the location has been denied. Please update the permission in Settings to enable the Photo Collage feature", complete: nil)
            case .authorizedAlways, .authorizedWhenInUse:
                break
            }
        }
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
        delegate?.FRDidTapCancel()
        self.dismiss(animated: true, completion: nil)
    }
    
    func okHandler() {
        let vc = MainViewController(uniqueId: userId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func previewDoneHandler() {
        delegate?.FRDidTapDone()
    }
    
    func displayAlert(notification: Notification) {
        if let info = notification.object as? [String: String] {
            let title = info["title"] ?? ""
            let msg = info["message"] ?? ""
            FRDisplayAlert(title: title, message: msg, complete: nil)
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

extension FRPhotoCollageCreate: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            let locValue:CLLocationCoordinate2D = location.coordinate
            debugPrint("locations = \(locValue.latitude) \(locValue.longitude)")
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        debugPrint("is changed")
        if status == .authorizedWhenInUse {
            debugPrint("when in use")
//            manager.startUpdatingLocation()
        } else if status == .denied {
            self.FRDisplayAlert(title: "Reminder", message: "The permission to access the location has been denied. Please update the permission in Settings to enable the Photo Collage feature", complete: nil)
        }
    }
}

