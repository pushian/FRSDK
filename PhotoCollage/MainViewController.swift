//
//  MainViewController.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 21/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {
    
    
    fileprivate var selectedIndex = 0
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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Photo Collage"
        let preBtn = UIBarButtonItem(title: "Preview", style: .plain, target: self, action: #selector(previewHandler))
        self.navigationItem.rightBarButtonItem = preBtn
        view.addSubview(infoLabel)
        view.addSubview(bkView)
        bkView.addSubview(overLay)
        bkView.image = Constants.testImages[selectedIndex]
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
//        self.post
        setConstraints()
        setupFrames()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.3) { 
            self.navigationController?.navigationBar.isHidden = false
        }
    }
    
    func setConstraints() {
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(Scale.scaleY(y: 20))
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
                    make.top.equalTo(Scale.scaleY(y: 20))
                    make.leading.equalTo(Scale.scaleX(x: 5))
                    make.width.equalTo(widths[index])
                    make.height.equalTo(heights[index])
                })
                frames[index].transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 180.0 * 8.0))
//                frames[index].image = #imageLiteral(resourceName: "p1")
                frames[index].applyBundleImage(name: "p1")
                let panGestureOne = UIPanGestureRecognizer(target: self, action: #selector(PanHandler))
                frames[index].addGestureRecognizer(panGestureOne)
                let pinchGestureOne = UIPinchGestureRecognizer(target: self, action: #selector(PinchHandler))
                frames[index].addGestureRecognizer(pinchGestureOne)
                let tapGestureOne = UITapGestureRecognizer(target: self, action: #selector(TapHandler))
                frames[index].addGestureRecognizer(tapGestureOne)
                
//                let rotateGestureOne = UIRotationGestureRecognizer(target: self, action: #selector(RotateHandlerOne))
//                frames[index].addGestureRecognizer(rotateGestureOne)
//                let t = uigesture
            case 1:
                frames[index].snp.makeConstraints({ (make) in
                    make.top.equalTo(Scale.scaleY(y: 53))
                    make.leading.equalTo(frames[0].snp.trailing).offset(Scale.scaleX(x: 51))
                    make.width.equalTo(widths[index])
                    make.height.equalTo(heights[index])
                })
                frames[index].transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 180.0 * 14.0))
//                frames[index].image = #imageLiteral(resourceName: "p2")
                frames[index].applyBundleImage(name: "p2")
                let panGestureTwo = UIPanGestureRecognizer(target: self, action: #selector(PanHandler))
                frames[index].addGestureRecognizer(panGestureTwo)
                let pinchGestureTwo = UIPinchGestureRecognizer(target: self, action: #selector(PinchHandler))
                frames[index].addGestureRecognizer(pinchGestureTwo)
                let tapGestureTwo = UITapGestureRecognizer(target: self, action: #selector(TapHandler))
                frames[index].addGestureRecognizer(tapGestureTwo)

            case 2:
                frames[index].snp.makeConstraints({ (make) in
                make.top.equalTo(Scale.scaleY(y: 26))
                make.trailing.equalTo(Scale.scaleX(x: -38))
                make.width.equalTo(widths[index])
                make.height.equalTo(heights[index])
                })
                frames[index].transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 180.0 * 23.0))
//                frames[index].image = #imageLiteral(resourceName: "p3")
                frames[index].applyBundleImage(name: "p3")
                let panGestureThree = UIPanGestureRecognizer(target: self, action: #selector(PanHandler))
                frames[index].addGestureRecognizer(panGestureThree)
                let pinchGestureThree = UIPinchGestureRecognizer(target: self, action: #selector(PinchHandler))
                frames[index].addGestureRecognizer(pinchGestureThree)
                let tapGestureThree = UITapGestureRecognizer(target: self, action: #selector(TapHandler))
                frames[index].addGestureRecognizer(tapGestureThree)
            case 3:
                frames[index].snp.makeConstraints({ (make) in
                    make.bottom.equalTo(Scale.scaleY(y: -27))
                    make.leading.equalTo(Scale.scaleX(x: 29))
                    make.width.equalTo(widths[index])
                    make.height.equalTo(heights[index])
                })
                frames[index].transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 180.0 * 9.0))
//                frames[index].image = #imageLiteral(resourceName: "p4")
                frames[index].applyBundleImage(name: "p4")
                let panGestureFour = UIPanGestureRecognizer(target: self, action: #selector(PanHandler))
                frames[index].addGestureRecognizer(panGestureFour)
                let pinchGestureFour = UIPinchGestureRecognizer(target: self, action: #selector(PinchHandler))
                frames[index].addGestureRecognizer(pinchGestureFour)
                let tapGestureFour = UITapGestureRecognizer(target: self, action: #selector(TapHandler))
                frames[index].addGestureRecognizer(tapGestureFour)
            default:
                frames[index].snp.makeConstraints({ (make) in
                    make.bottom.equalTo(Scale.scaleY(y: -36))
                    make.trailing.equalTo(Scale.scaleX(x: -24))
                    make.width.equalTo(widths[index])
                    make.height.equalTo(heights[index])
                })
                frames[index].transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 180.0 * 6.0))
                frames[index].noImage()
                let panGestureFive = UIPanGestureRecognizer(target: self, action: #selector(PanHandler))
                frames[index].addGestureRecognizer(panGestureFive)
                let pinchGestureFive = UIPinchGestureRecognizer(target: self, action: #selector(PinchHandler))
                frames[index].addGestureRecognizer(pinchGestureFive)
                let tapGestureFive = UITapGestureRecognizer(target: self, action: #selector(TapHandler))
                frames[index].addGestureRecognizer(tapGestureFive)
            }
        }
    }
    func previewHandler() {
        let image = UIImage(view: bkView)
        let vc = PreviewViewController(image: image)
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    func RotateHandlerOne(gesture: UIRotationGestureRecognizer) {
        debugPrint(gesture.rotation)
        var lastRotation = CGFloat()
//        self.view.bringSubview(toFront: viewRotate)
        if(gesture.state == .ended){
            lastRotation = 0.0;
        }
        let rotation = 0.0 - (lastRotation - gesture.rotation)
        // var point = rotateGesture.location(in: viewRotate)
        let currentTrans = gesture.view?.transform
        let newTrans = currentTrans!.rotated(by: rotation)
        gesture.view?.transform = newTrans
        lastRotation = gesture.rotation
    }
    func TapHandler(gesture: UITapGestureRecognizer) {
        let tag = (gesture.view)!.tag
        if tag == 4 {
            let actionSheet = UIActionSheet(title: "Add a Photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take a Photo", "Select from Gallery")
            actionSheet.show(in: self.view)
        } else {
            let actionSheet = UIActionSheet(title: "Edit or Remove Photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Edit Photo", "Remove Photo")
            actionSheet.show(in: self.view)
        }
    }
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
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
        switch (buttonIndex) {
        case 0: // Cancel
            break
        case 2: // Select from Library
            
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
                displayAlert(title: "Error", message: "This device doesn't have cameral roll.", complete: nil)
            }
        case 1: // Take photo
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            } else {
                displayAlert(title: "Error", message: "This device doesn't have camera.", complete: nil)
            }
        default:
            break
        }
    }
}


extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            let imageCropVC = RSKImageCropViewController(image: image)
//            imageCropVC.delegate = self
//            if picker.sourceType == .camera {
//                dismiss(animated: false, completion: nil)
//                let nav = UINavigationController(rootViewController: imageCropVC)
//                present(nav, animated: true, completion: nil)
//            } else {
//                picker.pushViewController(imageCropVC, animated: true)
//            }
        }
    }
}


