//
//  IGRPhotoTweakViewController.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit


@objc public protocol IGRPhotoTweakViewControllerDelegate: NSObjectProtocol {
    
    /**
     Called on image cropped.
     */
    @objc func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage)
    /**
     Called on cropping image canceled
     */
    
    @objc func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController)
}

@objc(IGRPhotoTweakViewController) open class IGRPhotoTweakViewController: UIViewController {
    
    //MARK: - Public VARs
    
    
    fileprivate var slider: UISlider! = {
        let t = UISlider()
        t.maximumValue = 180
        t.minimumValue = -180
//        t.set
        return t
    }()
    
    fileprivate var rotation = CGFloat()
    
    fileprivate var cancelBtn: UIButton! = {
        let t = UIButton()
        t.setTitle("Cancel", for: .normal)
        t.setTitleColor(.white, for: .normal)
        t.titleLabel?.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
        return t
    }()
    
    fileprivate var doneBtn: UIButton! = {
        let t = UIButton()
        t.setTitle("Done", for: .normal)
        t.setTitleColor(.white, for: .normal)
        t.titleLabel?.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
        return t
    }()
    
    fileprivate var changeBtn: UIButton! = {
        let t = UIButton()
        t.setTitle("CHANGE PHOTO", for: .normal)
        t.setTitleColor(.white, for: .normal)
        t.titleLabel?.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 12))
        t.backgroundColor = UIColor.phtMidGreen
        t.clipsToBounds = true
        t.layer.cornerRadius = Scale.scaleY(y: 40) / 2
        return t
    }()

    /*
     Image to process.
     */
    public var image: UIImage!
    
    /*
     The optional photo tweaks controller delegate.
     */
    public weak var delegate: IGRPhotoTweakViewControllerDelegate?
    
    //MARK: - Protected VARs
    
    /*
     Flag indicating whether the image cropped will be saved to photo library automatically. Defaults to YES.
     */
    internal var isAutoSaveToLibray: Bool = false
    
    //MARK: - Private VARs
    
    internal lazy var photoView: IGRPhotoTweakView! = { [unowned self] by in
        
        let photoView = IGRPhotoTweakView(frame: self.view.bounds,
                                          image: self.image,
                                          customizationDelegate: self)
        photoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(photoView)
        
        return photoView
        }()
    
    // MARK: - Life Cicle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        self.setupThemes()
        self.setupSubviews()
//        view.addSubview(changeBtn)
//        changeBtn.addTarget(self, action: #selector(changeHandler), for: .touchUpInside)

        view.addSubview(cancelBtn)
        view.addSubview(doneBtn)
        view.addSubview(slider)
        slider.addTarget(self, action: #selector(sliderHandler), for: UIControlEvents.valueChanged)
//        slider.addTarget(self, action: #selector(stopChangeAngle), for: UIControlEvents.editingDidEnd)

//        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(RotateHandler))
//        rotateGesture.delegate = self
//        view.addGestureRecognizer(rotateGesture)

        cancelBtn.addTarget(self, action: #selector(cancelHandler), for: .touchUpInside)
        doneBtn.addTarget(self, action: #selector(doneHandler), for: .touchUpInside)
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(Scale.scaleY(y: 29))
            make.leading.equalTo(Scale.scaleX(x: 13))
        }
        doneBtn.snp.makeConstraints { (make) in
            make.top.equalTo(cancelBtn)
            make.trailing.equalTo(Scale.scaleX(x: -13))
        }
//        changeBtn.snp.makeConstraints { (make) in
//            make.leading.equalTo(Scale.scaleX(x: 20))
//            make.trailing.equalTo(Scale.scaleX(x: -20))
//            make.centerX.equalToSuperview()
//            make.height.equalTo(Scale.scaleY(y: 40))
//            make.bottom.equalTo(Scale.scaleY(y: -20))
//        }
        slider.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 20))
            make.trailing.equalTo(Scale.scaleX(x: -20))
//
//            make.leading.equalTo(changeBtn)
//            make.trailing.equalTo(changeBtn)
            make.bottom.equalTo(Scale.scaleY(y: -20))
//            make.bottom.equalTo(changeBtn.snp.top).offset(Scale.scaleY(y: -20))
        }
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupSubviews() {
        self.view.sendSubview(toBack: self.photoView)
    }
    
//    func RotateHandler(gesture: UIRotationGestureRecognizer) {
//        changedAngle(value: rotation + gesture.rotation)
////        gesture.rotation = 0
//        rotation = gesture.rotation
//        switch gesture.state {
//        case .ended:
//            stopChangeAngle()
//        default:
//            break
//        }
//    //        gesture.view?.transform = (gesture.view?.transform)!.rotated(by: gesture.rotation)
//    //        gesture.rotation = 0
//    }

    func sliderHandler(sender: UISlider) {
        let value = sender.value
        changedAngle(value: CGFloat.pi * (CGFloat(value) / 180.0))
    }
    
    open func setupThemes() {
        IGRPhotoTweakView.appearance().backgroundColor = UIColor.photoTweakCanvasBackground()
        IGRPhotoContentView.appearance().backgroundColor = UIColor.clear
        IGRCropView.appearance().backgroundColor = UIColor.clear
        IGRCropGridLine.appearance().backgroundColor = UIColor.gridLine()
        IGRCropLine.appearance().backgroundColor = UIColor.cropLine()
        IGRCropCornerView.appearance().backgroundColor = UIColor.clear
        IGRCropCornerLine.appearance().backgroundColor = UIColor.cropLine()
        IGRCropMaskView.appearance().backgroundColor = UIColor.mask()
    }
    
    func cancelHandler() {
        _ = dismiss(animated: true, completion: nil)
    }
    
    func doneHandler() {
        cropAction()
//        self.delegate?.photoTweaksController(<#T##controller: IGRPhotoTweakViewController##IGRPhotoTweakViewController#>, didFinishWithCroppedImage: <#T##UIImage#>)
        _ = dismiss(animated: true, completion: nil)
    }
    
    func changeHandler() {
        let actionSheet = UIActionSheet(title: "Change Photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take a Photo", "Select from Gallery")
        actionSheet.show(in: self.view)
    }
    
    // MARK: - Public
    
    public func resetView() {
        self.photoView.resetView()
        self.stopChangeAngle()
    }
    
    public func dismissAction() {
        self.delegate?.photoTweaksControllerDidCancel(self)
    }
    
    public func cropAction() {
        var transform = CGAffineTransform.identity
        // translate
        let translation: CGPoint = self.photoView.photoTranslation
        transform = transform.translatedBy(x: translation.x, y: translation.y)
        // rotate
        transform = transform.rotated(by: self.photoView.angle)
        // scale
        
        let t: CGAffineTransform = self.photoView.photoContentView.transform
        let xScale: CGFloat = sqrt(t.a * t.a + t.c * t.c)
        let yScale: CGFloat = sqrt(t.b * t.b + t.d * t.d)
        transform = transform.scaledBy(x: xScale, y: yScale)
        
        if let fixedImage = self.image.cgImageWithFixedOrientation() {
            let imageRef = fixedImage.transformedImage(transform,
                                                       sourceSize: self.image.size,
                                                       outputWidth: self.image.size.width,
                                                       cropSize: self.photoView.cropView.frame.size,
                                                       imageViewSize: self.photoView.photoContentView.bounds.size)
            
            let image = UIImage(cgImage: imageRef)
            
            if self.isAutoSaveToLibray {
                
                self.saveToLibrary(image: image)
            }
            
            self.delegate?.photoTweaksController(self, didFinishWithCroppedImage: image)
        }
    }
}

extension IGRPhotoTweakViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension IGRPhotoTweakViewController: UIActionSheetDelegate {
    public func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch (buttonIndex) {
        case 0: // Cancel
            break
        case 2: // Select from Library // remove
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
        case 1: // Take photo // edit
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


extension IGRPhotoTweakViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
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
            //            self.theImage.image = image
            self.image = image
//            self.photoView.
            
//            self.setupThemes()
//            self.setupSubviews()
//            self.resetView()
            dismiss(animated: true, completion: nil)
        }
    }
}
