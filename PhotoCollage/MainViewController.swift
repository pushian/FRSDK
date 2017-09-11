//
//  MainViewController.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 21/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import PushianPhotoTweaks
import Photos
import SVProgressHUD
//import Async
import CoreImage
import CoreLocation

class MainViewController: BaseViewController {

    //    fileprivate var
//    fileprivate var actionSheet
    fileprivate var userId = ""
    fileprivate let locationManager = CLLocationManager()
    fileprivate var currentLat: String?
    fileprivate var currentLon: String?
    
    fileprivate var images: [UIImage?] = [nil, nil, nil, nil, nil]
    fileprivate var lats: [String?] = [nil, nil, nil, nil, nil]
    fileprivate var lons: [String?] = [nil, nil, nil, nil, nil]
    
    fileprivate var totalCount = 0
    fileprivate var count = 0
    fileprivate var validImages = [UIImage]()
    fileprivate var validLats = [String?]()
    fileprivate var validLons = [String?]()
    
    fileprivate var mostFaces: UIImage?
    fileprivate var oneFace = [UIImage]()
    fileprivate var moreFace = [UIImage]()
    fileprivate var noFace = [UIImage]()
    
    fileprivate var mostFaceLat: String?
    fileprivate var mostFaceLon: String?
    fileprivate var noFaceLat = [String?]()
    fileprivate var noFaceLon = [String?]()
    fileprivate var oneFaceLat = [String?]()
    fileprivate var oneFaceLon = [String?]()
    fileprivate var moreFaceLat = [String?]()
    fileprivate var moreFaceLon = [String?]()
    
    fileprivate var didLoad = false
    fileprivate var selectedIndex = 0
    fileprivate var selectedFrame = 0
    fileprivate var infoLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
        t.textColor = UIColor.phtGunmetal
        t.numberOfLines = 0
        t.text = "We think these are your best experiences today! Share this Limited Edition Sentosa collage with your friends! Tap a photo to change."
        t.textAlignment = .center
        return t
    }()
    
    fileprivate var bkView: UIImageView = {
        let t = UIImageView()
        t.backgroundColor = UIColor.phtWhiteTwo
        t.contentMode = .scaleAspectFill
        t.isUserInteractionEnabled = true
        t.clipsToBounds = true
        return t
    }()
    
    fileprivate var overLay: UIView! = {
        let t = UIView()
        t.backgroundColor = .white
        t.alpha = 0.3
        t.isUserInteractionEnabled = true
        return t
    }()
    fileprivate var collectionView: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        let size = Scale.scaleY(y: 89)
        layout.sectionInset = UIEdgeInsets(top: 0, left: Scale.scaleX(x: 20), bottom: 0, right: Scale.scaleX(x: 20))
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = Scale.scaleX(x: 20)
        layout.minimumLineSpacing = Scale.scaleX(x: 20)
        layout.scrollDirection = .horizontal
        let t = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        t.register(BKViewCollectionViewCell.self, forCellWithReuseIdentifier: BKViewCollectionViewCell.reuseIdentifier)
        t.backgroundColor = UIColor.white
        t.alwaysBounceHorizontal = true
        return t
    }()
    
    fileprivate var frames = [PhotoFrame(frame: CGRect.zero), PhotoFrame(frame: CGRect.zero), PhotoFrame(frame: CGRect.zero), PhotoFrame(frame: CGRect.zero), PhotoFrame(frame: CGRect.zero)]
    fileprivate var widths = [106, 92, 60, 118, 166]
    fileprivate var heights = [147, 128, 95, 139, 120]
//    fileprivate var xs = []
    
    
    init(uniqueId: String) {
        super.init(nibName: nil, bundle: nil)
        self.userId = uniqueId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        debugPrint(self.navigationItem.leftBarButtonItem)
        debugPrint(self.navigationItem.backBarButtonItem?.isEnabled)
        self.navigationItem.backBarButtonItem?.isEnabled = false
        debugPrint(self.navigationItem.backBarButtonItem?.isEnabled)

        view.addSubview(infoLabel)
        view.addSubview(bkView)
        bkView.addSubview(overLay)
        bkView.image = Constants.testImages[selectedIndex]
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
//        self.post
        setConstraints()
//        getPhoto()
//        getPhoto { (image) in
//            if let image = image {
//            }
//        }
        
        setRightBtn(title: "Preview")
        setTitle(title: "Photo Collage")
       

        if !didLoad {
            checkStatus()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("i am going to start")
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        debugPrint("i am going to stop")
        locationManager.stopUpdatingLocation()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        for each in frames {
//            if each.image != nil {
//                resizeFrame(index: frames.index(of: each)!)
//            }
//        }
//    }
    
    func setConstraints() {
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom).offset(Scale.scaleY(y: 20))
            make.leading.equalTo(Scale.scaleX(x: 20))
            make.trailing.equalTo(Scale.scaleX(x: -20))
        }
        bkView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Constants.mainWidth * Constants.bkImageRatio)
            make.top.equalTo(infoLabel.snp.bottom).offset(Scale.scaleY(y: 14))
        }
        overLay.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(bkView.snp.bottom)
        }
    }
    
    
    func checkStatus() {
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            debugPrint("Access has been granted.")
            SVProgressHUD.show()
//            Async.background {
            DispatchQueue.global(qos: .background).async {
                self.getPhoto()
            }
//            getPhoto()
        }
            
        else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
            self.FRDisplayAlert(title: "Reminder", message: "The permission to access the camera roll has been denied. Please update the permission in Settings to enable the Photo Collage feature", complete: nil)
//            debugPrint("Access has been denied.")
//            let alertController = UIAlertController(title: "Reminder", message: "The permission to access the camera roll has been denied. You may change the permission to enable the Photo Collage feature", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Change Permission", style: .default, handler: { (action) in
//                self.settingHandler()
//            }))
//            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
//            self.present(alertController, animated: true, completion: nil)
        }
            
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
//            PHPhotoLibrary.reque
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    debugPrint("has been granted 1st time")
                    SVProgressHUD.show()
//                    Async.background {
                    DispatchQueue.global(qos: .background).async {
                        self.getPhoto()
                    }
                }
                    
                else {
                    self.FRDisplayAlert(title: "Reminder", message: "The permission to access the camera roll has been denied. Please update the permission in Settings to enable the Photo Collage feature", complete: nil)
//                    debugPrint("has not been granted")
//                    let alertController = UIAlertController(title: "Reminder", message: "The permission to access the camera roll has been denied. You may change the permission to enable the Photo Collage feature", preferredStyle: .alert)
//                    alertController.addAction(UIAlertAction(title: "Change Permission", style: .default, handler: { (action) in
//                        //                self.ignoreBudget = true
//                        self.settingHandler()
//                    }))
//                    alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
//                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
            
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
            debugPrint("Restricted access")
        }
    }
    
    
    
    func getPhoto() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        //        fetchOptions.des/
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
//        requestOptions.deliveryMode = .fastFormat
        
        let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        debugPrint(fetchResult.count)
        
        //
        let fromRange = IndexSet(0...fetchResult.count - 1)
        let latest = fetchResult.objects(at: fromRange)
        let valid = latest.filter { (asset) -> Bool in
            if let date = asset.creationDate {
                let day = date.daysBetweenDate(toDate: Date())
                if day > 2 {
                    return false
                }
                debugPrint("===========")
                debugPrint(date.daysBetweenDate(toDate: Date()))
                
            }
            if let location = asset.location?.coordinate {
                for each in Constants.sentosaRegions {
                    if each.contains(location) {
                        return true
                    }
                }
                return false
            }
            return false
        }
        
        
        debugPrint(valid.count)
        self.validImages = [UIImage]()
        self.mostFaces = nil
        self.oneFace = [UIImage]()
        self.moreFace = [UIImage]()
        self.noFace = [UIImage]()
        
        debugPrint("total count is \(valid.count)")
        totalCount = valid.count
        count = 0
        let manager = PHImageManager.default()
        
        
        if valid.count > 0 {
            //            let count = valid.count > 4 ? 4 : valid.count
            for each in 0..<valid.count {
                let ass = valid[each]
//                let targetSize = CGSize(width: ass.pixelWidth, height: ass.pixelHeight)
                let ratio = Double(ass.pixelWidth) / Double(ass.pixelHeight)
                let theMax: Double = 1024 / 4
                var width: Double = theMax
                var height: Double = 0
                if ratio > 1 {
                    height = theMax / ratio
                } else {
                    height = theMax
                    width = theMax * ratio
                }
                
                let targetSize = CGSize(width: width, height: height)
                
                let lat = ass.location?.coordinate.latitude
                let lon = ass.location?.coordinate.longitude
                validLats.append(String(lat!))
                validLons.append(String(lon!))
                
                manager.requestImage(for: ass,
                                     targetSize: targetSize,
                                     contentMode: .aspectFit,
                                     options: requestOptions,
                                     resultHandler: { image, info in
                                        self.count = self.count + 1
                                        if let image = image {
                                            self.validImages.append(image)
                                        }
                })
            }
        }
        
        while self.count != self.totalCount {
            debugPrint(self.count)
        }
        
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        var tmpCount = 0
        var max: Int? = 0
        for (face, (lat, lon)) in zip(self.validImages, zip(self.validLats, self.validLons)){
            tmpCount = tmpCount + 1
            let ciImage = CIImage(image: face)
//            let accuracy = cide
            let foundFaces = detector?.features(in: ciImage!)
            if let count = foundFaces?.count {
                if count > max! {
                    self.mostFaces = face
                    self.mostFaceLat = lat
                    self.mostFaceLon = lon
                    max = foundFaces?.count
                } else if count == 0 {
                    self.noFace.append(face)
                    self.noFaceLat.append(lat)
                    self.noFaceLon.append(lon)
                } else if count == 1 {
                    self.oneFace.append(face)
                    self.oneFaceLat.append(lat)
                    self.oneFaceLon.append(lon)
                } else {
                    self.moreFace.append(face)
                    self.moreFaceLat.append(lat)
                    self.moreFaceLon.append(lon)
                }
            }
        }
        
        self.validImages = [UIImage]()
        SVProgressHUD.dismiss()
//        Async.main{
        DispatchQueue.main.async {

            self.setupFrames()
        }
        
    }
    
//    func getPhoto(queryCallback: @escaping ((UIImage?) -> Void)) {
////
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
////        fetchOptions.des/
//        
//        let requestOptions = PHImageRequestOptions()
//        requestOptions.isSynchronous = true
//        
//        let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
//        
//        debugPrint(fetchResult.count)
//        
//        
////        
//        let fromRange = IndexSet(0...fetchResult.count - 1)
//        let lastest100 = fetchResult.objects(at: fromRange)
//        let valid = lastest100.filter { (asset) -> Bool in
//            if let location = asset.location?.coordinate {
//                for each in Constants.sentosaRegions {
//                    if each.contains(location) {
//                        return true
//                    }
//                }
//                return false
//            }
//            return false
//        }
//        
//        
//        debugPrint(valid.count)
//        
//        if valid.count > 0 {
//            let manager = PHImageManager.default()
//            let asset = valid[0]
//            let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
//            
//            manager.requestImage(for: asset,
//                                 targetSize: targetSize,
//                                 contentMode: .aspectFit,
//                                 options: requestOptions,
//                                 resultHandler: { image, info in
//                                    queryCallback(image)
//            })
//        }
//        
////        if let asset = fetchResult.firstObject {
////            debugPrint(asset.location?.coordinate.latitude)
////            debugPrint(asset.location?.coordinate.longitude)
////            
////            let manager = PHImageManager.default()
////            
////            let targetSize = size == nil ? CGSize(width: asset.pixelWidth, height: asset.pixelHeight) : size!
////            
////            manager.requestImage(for: asset,
////                                 targetSize: targetSize,
////                                 contentMode: .aspectFit,
////                                 options: requestOptions,
////                                 resultHandler: { image, info in
////                                    queryCallback(image)
////            })
////        }
//        
//    }
    
    func settingHandler() {
        if let url = URL(string:UIApplicationOpenSettingsURLString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (finished) in
                    debugPrint("finished")
                })
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func setupFrames() {
        var tag = 0
        for each in frames {
            each.tag = tag
            tag += 1
            bkView.addSubview(each)
        }
        
        for index in 0..<frames.count {
            switch index {
            case 0:
                frames[index].snp.makeConstraints({ (make) in
                    make.top.equalTo(Scale.scaleY(y: 16))
                    make.leading.equalTo(Scale.scaleX(x: 1))
                    make.width.equalTo(widths[index])
                    make.height.equalTo(heights[index])
                })
                frames[index].transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 180.0 * 8.0))
                let panGestureOne = UIPanGestureRecognizer(target: self, action: #selector(PanHandler))
                frames[index].addGestureRecognizer(panGestureOne)
                let pinchGestureOne = UIPinchGestureRecognizer(target: self, action: #selector(PinchHandler))
                frames[index].addGestureRecognizer(pinchGestureOne)
                let tapGestureOne = UITapGestureRecognizer(target: self, action: #selector(TapHandler))
                frames[index].addGestureRecognizer(tapGestureOne)
                let rotateGestureOne = UIRotationGestureRecognizer(target: self, action: #selector(RotateHandler))
                frames[index].addGestureRecognizer(rotateGestureOne)
                pinchGestureOne.delegate = self
                rotateGestureOne.delegate = self
            case 1:
                frames[index].snp.makeConstraints({ (make) in
                    make.top.equalTo(Scale.scaleY(y: 49))
                    make.leading.equalTo(Scale.scaleX(x: 162))
                    make.width.equalTo(widths[index])
                    make.height.equalTo(heights[index])
                })
                frames[index].transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 180.0 * 14.0))
                let panGestureTwo = UIPanGestureRecognizer(target: self, action: #selector(PanHandler))
                frames[index].addGestureRecognizer(panGestureTwo)
                let pinchGestureTwo = UIPinchGestureRecognizer(target: self, action: #selector(PinchHandler))
                frames[index].addGestureRecognizer(pinchGestureTwo)
                let tapGestureTwo = UITapGestureRecognizer(target: self, action: #selector(TapHandler))
                frames[index].addGestureRecognizer(tapGestureTwo)
                let rotateGestureTwo = UIRotationGestureRecognizer(target: self, action: #selector(RotateHandler))
                frames[index].addGestureRecognizer(rotateGestureTwo)
                pinchGestureTwo.delegate = self
                rotateGestureTwo.delegate = self
            case 2:
                frames[index].snp.makeConstraints({ (make) in
                make.top.equalTo(Scale.scaleY(y: 22))
                make.trailing.equalTo(Scale.scaleX(x: -34))
                make.width.equalTo(widths[index])
                make.height.equalTo(heights[index])
                })
                frames[index].transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 180.0 * 23.0))
                let panGestureThree = UIPanGestureRecognizer(target: self, action: #selector(PanHandler))
                frames[index].addGestureRecognizer(panGestureThree)
                let pinchGestureThree = UIPinchGestureRecognizer(target: self, action: #selector(PinchHandler))
                frames[index].addGestureRecognizer(pinchGestureThree)
                let tapGestureThree = UITapGestureRecognizer(target: self, action: #selector(TapHandler))
                frames[index].addGestureRecognizer(tapGestureThree)
                let rotateGestureThree = UIRotationGestureRecognizer(target: self, action: #selector(RotateHandler))
                frames[index].addGestureRecognizer(rotateGestureThree)
                pinchGestureThree.delegate = self
                rotateGestureThree.delegate = self
            case 3:
                frames[index].snp.makeConstraints({ (make) in
                    make.bottom.equalTo(Scale.scaleY(y: -35))
                    make.leading.equalTo(Scale.scaleX(x: 25))
                    make.width.equalTo(widths[index])
                    make.height.equalTo(heights[index])
                })
                frames[index].transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 180.0 * 9.0))
               
                let panGestureFour = UIPanGestureRecognizer(target: self, action: #selector(PanHandler))
                frames[index].addGestureRecognizer(panGestureFour)
                let pinchGestureFour = UIPinchGestureRecognizer(target: self, action: #selector(PinchHandler))
                frames[index].addGestureRecognizer(pinchGestureFour)
                let tapGestureFour = UITapGestureRecognizer(target: self, action: #selector(TapHandler))
                frames[index].addGestureRecognizer(tapGestureFour)
                let rotateGestureFour = UIRotationGestureRecognizer(target: self, action: #selector(RotateHandler))
                frames[index].addGestureRecognizer(rotateGestureFour)
                rotateGestureFour.delegate = self
                rotateGestureFour.delegate = self
            default:
                frames[index].snp.makeConstraints({ (make) in
                    make.bottom.equalTo(Scale.scaleY(y: -60))
                    make.trailing.equalTo(Scale.scaleX(x: -20))
                    make.width.equalTo(widths[index])
                    make.height.equalTo(heights[index])
                })
                frames[index].transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 180.0 * 6.0))
                let panGestureFive = UIPanGestureRecognizer(target: self, action: #selector(PanHandler))
                frames[index].addGestureRecognizer(panGestureFive)
                let pinchGestureFive = UIPinchGestureRecognizer(target: self, action: #selector(PinchHandler))
                frames[index].addGestureRecognizer(pinchGestureFive)
                let tapGestureFive = UITapGestureRecognizer(target: self, action: #selector(TapHandler))
                frames[index].addGestureRecognizer(tapGestureFive)
                let rotateGestureFive = UIRotationGestureRecognizer(target: self, action: #selector(RotateHandler))
                frames[index].addGestureRecognizer(rotateGestureFive)
                pinchGestureFive.delegate = self
                rotateGestureFive.delegate = self
            }
        }
        
        for each in frames {
            each.noImage(withLabelOne: false)
        }
        frames[4].noImage()
        
        var index = 0
        if !applyNoFace(index: index) {
            if !applyOneFace(index: index) {
                if !applyMoreFace(index: index) {
                    if !applyMostFace(index: index) {
                        
                    }
                }
            }
        }
        index = 1
        if !applyOneFace(index: index) {
            if !applyMoreFace(index: index) {
                if !applyMostFace(index: index) {
                    if !applyNoFace(index: index) {
                        
                    }
                }
            }
        }
        index = 2
        if !applyMoreFace(index: index) {
            if !applyMostFace(index: index) {
                if !applyOneFace(index: index) {
                    if !applyNoFace(index: index) {
                        
                    }
                }
            }
        }
        index = 3
        if !applyMostFace(index: index) {
            if !applyMoreFace(index: index) {
                if !applyOneFace(index: index) {
                    if !applyNoFace(index: index) {
                        
                    }
                }
            }
        }
        
    }
    
    func applyNoFace(index: Int) -> Bool {
        let frame = frames[index]
        if noFace.isEmpty {
            return false
        }
        let randomIndex = Int(arc4random_uniform(UInt32(noFace.count)))
        let image = noFace[randomIndex]
        frame.image = image
        frame.gotImage()
        images[index] = image
        lats[index] = noFaceLat[randomIndex]
        lons[index] = noFaceLon[randomIndex]
        noFace.remove(at: randomIndex)
        return true

    }
    
    func applyOneFace(index: Int) -> Bool {
        let frame = frames[index]
        if oneFace.isEmpty {
            return false
        }
        let randomIndex = Int(arc4random_uniform(UInt32(oneFace.count)))
        let image = oneFace[randomIndex]
        frame.image = image
        frame.gotImage()
        images[index] = image
        lats[index] = oneFaceLat[randomIndex]
        lons[index] = oneFaceLon[randomIndex]
        oneFace.remove(at: randomIndex)
        return true
    }
    
    func applyMoreFace(index: Int) -> Bool {
        let frame = frames[index]
        
        if moreFace.isEmpty {
            return false
        }
        let randomIndex = Int(arc4random_uniform(UInt32(moreFace.count)))
        let image = moreFace[randomIndex]
        frame.image = image
        frame.gotImage()
        images[index] = image
        lats[index] = moreFaceLat[randomIndex]
        lons[index] = moreFaceLon[randomIndex]
        moreFace.remove(at: randomIndex)
        return true
    }
    
    func applyMostFace(index: Int) -> Bool {
        let frame = frames[index]

        if mostFaces == nil {
            return false
        }
        frame.image = mostFaces!
        frame.gotImage()
        images[index] = mostFaces
        lats[index] = mostFaceLat
        lons[index] = mostFaceLon
        mostFaces = nil
        return true
    }
    
    override func rightHandler() {
        super.rightHandler()
        for each in frames {
            if each.image == nil {
                FRDisplayAlert(title: "Reminder", message: "Please ensure there is no empty frame!", complete: nil)
                return
            }
        }
        let image = UIImage(view: bkView)
        let vc = PreviewViewController(image: image, images: images, userId: userId, lats: lats, lons: lons)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func leftHandler() {
        let alertController = UIAlertController(title: "Reminder", message: "All the photos will be reset. Are you sure you want to continue?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)

    }
    
    func PanHandler(gesture: UIPanGestureRecognizer) {
        if ((gesture.state == .changed) || (gesture.state == .ended)) {
            let translation = gesture.translation(in: bkView)
            gesture.view?.center = CGPoint(x: (gesture.view?.center.x)! + translation.x, y: (gesture.view?.center.y)! + translation.y)
            gesture.setTranslation(CGPoint.zero, in: bkView)
        }
    }
//    func PanHandlerTwo(gesture: UIPanGestureRecognizer) {
//        if ((gesture.state == .changed) || (gesture.state == .ended)) {
//            let translation = gesture.translation(in: bkView)
//            gesture.view?.center = CGPoint(x: (gesture.view?.center.x)! + translation.x, y: (gesture.view?.center.y)! + translation.y)
//            gesture.setTranslation(CGPoint.zero, in: bkView)
//        }
//    }
//
//    func PanHandlerThree(gesture: UIPanGestureRecognizer) {
//        if ((gesture.state == .changed) || (gesture.state == .ended)) {
//            let translation = gesture.translation(in: bkView)
//            gesture.view?.center = CGPoint(x: (gesture.view?.center.x)! + translation.x, y: (gesture.view?.center.y)! + translation.y)
//            gesture.setTranslation(CGPoint.zero, in: bkView)
//        }
//    }
//
//    func PanHandlerFour(gesture: UIPanGestureRecognizer) {
//        if ((gesture.state == .changed) || (gesture.state == .ended)) {
//            let translation = gesture.translation(in: bkView)
//            gesture.view?.center = CGPoint(x: (gesture.view?.center.x)! + translation.x, y: (gesture.view?.center.y)! + translation.y)
//            gesture.setTranslation(CGPoint.zero, in: bkView)
//        }
//    }
//    func PanHandlerFive(gesture: UIPanGestureRecognizer) {
//        if ((gesture.state == .changed) || (gesture.state == .ended)) {
//            let translation = gesture.translation(in: bkView)
//            gesture.view?.center = CGPoint(x: (gesture.view?.center.x)! + translation.x, y: (gesture.view?.center.y)! + translation.y)
//            gesture.setTranslation(CGPoint.zero, in: bkView)
//        }
//    }

    func PinchHandler(gesture: UIPinchGestureRecognizer) {
//        debugPrint(gesture.s)
        gesture.view!.transform = gesture.view!.transform.scaledBy(x: gesture.scale, y: gesture.scale);
        gesture.scale = 1;
    }
    
    var lastRotation = CGFloat()

    func RotateHandler(gesture: UIRotationGestureRecognizer) {
        gesture.view?.transform = (gesture.view?.transform)!.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
    
    func TapHandler(gesture: UITapGestureRecognizer) {
        let tag = (gesture.view)!.tag
        selectedFrame = tag
        if frames[selectedFrame].image == nil {
            let actionSheet = UIActionSheet(title: "Add A Photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take A Photo", "Select From Gallery")
            actionSheet.show(in: self.view)
        } else {
            let actionSheet = UIActionSheet(title: "Edit Photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Crop & Rotate", "Replace", "Remove")
            actionSheet.show(in: self.view)
        }
    }
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BKViewCollectionViewCell.reuseIdentifier, for: indexPath as IndexPath) as! BKViewCollectionViewCell
        let image = Constants.testImages[indexPath.row]
        cell.configureWith(image: image)
        if indexPath.row == selectedIndex {
            cell.getSelected()
        } else {
            cell.getUnselected()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath as IndexPath, animated: false)
        selectedIndex = indexPath.row
        bkView.image = Constants.testImages[selectedIndex]
        collectionView.reloadData()
    }
    
}


extension MainViewController: UIActionSheetDelegate {
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        let title = actionSheet.buttonTitle(at: buttonIndex)
        switch  title! {
        case "Cancel":
            break
        case "Take A Photo":
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            } else {
                FRDisplayAlert(title: "Error", message: "This device doesn't have camera.", complete: nil)
            }
        case "Select From Gallery":
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let picker = UIImagePickerController()
                
                picker.delegate = self
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: {
                    let backButton = UIBarButtonItem()
                    backButton.title = ""
                    picker.viewControllers[0].navigationItem.backBarButtonItem = backButton
                })
            } else {
                FRDisplayAlert(title: "Error", message: "This device doesn't have cameral roll.", complete: nil)
            }
        case "Crop & Rotate":
            let vc = IGRPhotoTweakViewController()
            vc.image = self.frames[selectedFrame].image
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isHidden = true
            self.present(nav, animated: true, completion: nil)
        case "Replace":
            let actionSheet = UIActionSheet(title: "Replace a Photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take A Photo", "Select From Gallery")
            actionSheet.show(in: self.view)
        case "Remove":
            let alertController = UIAlertController(title: "", message: "Are you sure to remove this photo?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                self.frames[self.selectedFrame].snp.removeConstraints()
                self.frames[self.selectedFrame].removeFromSuperview()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)

        default:
            break
        }
//        switch (buttonIndex) {
//        case 0: // Cancel
//            break
//        case 3: //Remove
//            let alertController = UIAlertController(title: "", message: "Are you sure to remove this photo?", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
//                self.frames[self.selectedFrame].snp.removeConstraints()
//                self.frames[self.selectedFrame].removeFromSuperview()
//            }))
//            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
//            present(alertController, animated: true, completion: nil)
//        case 2: // Select from Library // Replace
//            
//            if frames[selectedFrame].image == nil {
//                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//                    let picker = UIImagePickerController()
//                    
//                    picker.delegate = self
//                    picker.sourceType = .photoLibrary
//                    self.present(picker, animated: true, completion: {
//                        let backButton = UIBarButtonItem()
//                        backButton.title = ""
//                        picker.viewControllers[0].navigationItem.backBarButtonItem = backButton
//                    })
//                } else {
//                    displayAlert(title: "Error", message: "This device doesn't have cameral roll.", complete: nil)
//                }
//            } else {
//                let actionSheet = UIActionSheet(title: "Replace a Photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take a Photo", "Select from Gallery")
//                actionSheet.show(in: self.view)
//            }
//        case 1: // Take photo // edit
//            if frames[selectedFrame].image == nil {
//                if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                    let picker = UIImagePickerController()
//                    picker.delegate = self
//                    picker.sourceType = .camera
//                    self.present(picker, animated: true, completion: nil)
//                } else {
//                    displayAlert(title: "Error", message: "This device doesn't have camera.", complete: nil)
//                }
//            } else {
//                let vc = IGRPhotoTweakViewController()
//                vc.image = self.frames[selectedFrame].image
//                vc.delegate = self
//                let nav = UINavigationController(rootViewController: vc)
//                nav.navigationBar.isHidden = true
//                self.present(nav, animated: true, completion: nil)
//            }
//        default:
//            break
//        }
    }
}


extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        debugPrint("didFinish")
        if picker.sourceType == .photoLibrary {
            debugPrint("i am using photos")
            if let URL = info[UIImagePickerControllerReferenceURL] as? URL {
                debugPrint("got url")
                let opts = PHFetchOptions()
                opts.fetchLimit = 1
                let assets = PHAsset.fetchAssets(withALAssetURLs: [URL], options: opts)
                let asset = assets[0]
                // The location is "asset.location", as a CLLocation
                debugPrint()
                debugPrint(asset.location?.coordinate.longitude)
                if let location = asset.location {
                    let lat = String(location.coordinate.latitude)
                    lats[selectedFrame] = lat
                    let lon = String(location.coordinate.longitude)
                    lons[selectedFrame] = lon
                }
                // ... Other stuff like dismiss omitted
            }
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.frames[selectedFrame].image = image
                self.images[selectedFrame] = image
                self.frames[selectedFrame].gotImage()
//                dismiss(animated: true, completion: nil)
                dismiss(animated: true, completion: { 
                    
                    let vc = IGRPhotoTweakViewController()
                    vc.image = self.frames[self.selectedFrame].image
                    vc.delegate = self
                    let nav = UINavigationController(rootViewController: vc)
                    nav.navigationBar.isHidden = true
                    self.present(nav, animated: true, completion: nil)
                })
            }
        } else {
            debugPrint("i am using camera")
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.frames[selectedFrame].image = image
                self.images[selectedFrame] = image
                lats[selectedFrame] = currentLat
                lons[selectedFrame] = currentLon
                self.frames[selectedFrame].gotImage()
                dismiss(animated: true, completion: {
                    let vc = IGRPhotoTweakViewController()
                    vc.image = self.frames[self.selectedFrame].image
                    vc.delegate = self
                    let nav = UINavigationController(rootViewController: vc)
                    nav.navigationBar.isHidden = true
                    self.present(nav, animated: true, completion: nil)
                })
            }
        }
       
        
        
    }
}
extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//extension MainViewController: EditPhotoViewControllerDelegate {
//    func didEndEdit(image: UIImage) {
//        frames[selectedFrame].image = image
//    }
//}

extension MainViewController: IGRPhotoTweakViewControllerDelegate {
    /**
     Called on cropping image canceled
     */
    @objc func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController) {
    }

    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage) {
        frames[selectedFrame].image = croppedImage
        self.images[selectedFrame] = croppedImage
        resizeFrame(index: selectedFrame)
    }
    
    func resizeFrame(index: Int) {
        debugPrint("resizing frame")
        let width = (frames[index].image)!.size.width
        let height = (frames[index].image)!.size.height
        debugPrint(width)
        debugPrint(height)
        let ratio = width / height
        let originalWidth = frames[selectedFrame].bounds.width
        let originalHeight = frames[selectedFrame].bounds.height
        debugPrint(originalWidth)
        debugPrint(originalHeight)
        let max = originalWidth > originalHeight ? originalWidth : originalHeight
        
        if ratio > 1 {
            frames[selectedFrame].bounds.size.width = max
            frames[selectedFrame].bounds.size.height = max / ratio
        } else {
            frames[selectedFrame].bounds.size.height = max
            frames[selectedFrame].bounds.size.width = max * ratio
        }
    }
}

//extension MainViewController: 

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            let locValue:CLLocationCoordinate2D = location.coordinate
            debugPrint("locations = \(locValue.latitude) \(locValue.longitude)")
            currentLat = String(locValue.latitude)
            currentLon = String(locValue.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        debugPrint("is changed")
        if status == .authorizedWhenInUse {
            debugPrint("when in use")
            manager.startUpdatingLocation()
        }
    }
}

