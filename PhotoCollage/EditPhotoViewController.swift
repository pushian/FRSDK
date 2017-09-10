////
////  EditPhotoViewController.swift
////  PhotoCollage
////
////  Created by Yangfan Liu on 28/8/17.
////  Copyright © 2017 Yangfan Liu. All rights reserved.
////
//
//import UIKit
//
//protocol EditPhotoViewControllerDelegate: class {
//    func didEndEdit(image: UIImage)
//}
//class EditPhotoViewController: BaseViewController {
//    
//    weak var delegate: EditPhotoViewControllerDelegate?
//    
//    fileprivate var original = UIImage()
//    fileprivate var new = UIImage()
//
//    fileprivate var container: UIView! = {
//        let t = UIView()
//        t.backgroundColor = .white
//        return t
//    }()
//    
//    fileprivate var changeBtn: UIButton! = {
//        let t = UIButton()
//        t.setTitle("CHANGE PHOTO", for: .normal)
//        t.setTitleColor(.white, for: .normal)
//        t.titleLabel?.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 12))
//        t.backgroundColor = UIColor.phtMidGreen
//        t.clipsToBounds = true
//        t.layer.cornerRadius = Scale.scaleY(y: 40) / 2
//        return t
//    }()
//
//    init(image: UIImage) {
//        super.init(nibName: nil, bundle: nil)
//        self.original = image
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        navigationItem.title = "Edit Photo"
//        let leftBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelHandler))
//        let rightBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneHandler))
//        navigationItem.leftBarButtonItem = leftBtn
//        navigationItem.rightBarButtonItem = rightBtn
//        view.addSubview(container)
//        view.addSubview(changeBtn)
//        let vc = IGRPhotoTweakViewController()
//        vc.image = original
//        vc.changedAngle(value: CGFloat.pi / 4)
////        present(vc, animated: true, completion: nil)
//    
//        addChildViewController(vc)
//        vc.view.frame = container.bounds
//        container.addSubview(vc.view)
//        vc.didMove(toParentViewController: self)
//
//        changeBtn.addTarget(self, action: #selector(changeHandler), for: .touchUpInside)
//        container.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.top.equalToSuperview()
//            make.bottom.equalTo(changeBtn.snp.top).offset(Scale.scaleY(y: -20))
//        }
//        changeBtn.snp.makeConstraints { (make) in
//            make.leading.equalTo(Scale.scaleX(x: 20))
//            make.trailing.equalTo(Scale.scaleX(x: -20))
//            make.centerX.equalToSuperview()
//            make.height.equalTo(Scale.scaleY(y: 40))
//            make.bottom.equalTo(Scale.scaleY(y: -20))
//        }
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func cancelHandler() {
//        _ = dismiss(animated: true, completion: nil)
//    }
//    
//    func doneHandler() {
////        new = (theImage.image)!
//        delegate?.didEndEdit(image: new)
//        _ = dismiss(animated: true, completion: nil)
//    }
//    
//    func changeHandler() {
//        let actionSheet = UIActionSheet(title: "Add a Photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take a Photo", "Select from Gallery")
//        actionSheet.show(in: self.view)
//    }
//    
//    
//}
//
//
//extension EditPhotoViewController: UIActionSheetDelegate {
//    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
//        switch (buttonIndex) {
//        case 0: // Cancel
//            break
//        case 2: // Select from Library // remove
//            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//                let picker = UIImagePickerController()
//                
//                picker.delegate = self
//                picker.sourceType = .photoLibrary
//                self.present(picker, animated: true, completion: {
//                    let backButton = UIBarButtonItem()
//                    backButton.title = ""
//                    picker.viewControllers[0].navigationItem.backBarButtonItem = backButton
//                })
//            } else {
//                FRDisplayAlert(title: "Error", message: "This device doesn't have cameral roll.", complete: nil)
//            }
//        case 1: // Take photo // edit
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                let picker = UIImagePickerController()
//                picker.delegate = self
//                picker.sourceType = .camera
//                self.present(picker, animated: true, completion: nil)
//            } else {
//                FRDisplayAlert(title: "Error", message: "This device doesn't have camera.", complete: nil)
//            }
//        default:
//            break
//        }
//    }
//}
//
//
//extension EditPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            //            let imageCropVC = RSKImageCropViewController(image: image)
//            //            imageCropVC.delegate = self
//            //            if picker.sourceType == .camera {
//            //                dismiss(animated: false, completion: nil)
//            //                let nav = UINavigationController(rootViewController: imageCropVC)
//            //                present(nav, animated: true, completion: nil)
//            //            } else {
//            //                picker.pushViewController(imageCropVC, animated: true)
//            //            }
////            self.theImage.image = image
//            dismiss(animated: true, completion: nil)
//        }
//    }
//}
