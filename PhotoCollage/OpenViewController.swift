//
//  ViewController.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 21/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class OpenViewController: UIViewController {

    fileprivate var sdkBtn: UIButton! = {
        let t = UIButton()
        t.setTitle("SDK Test", for: .normal)
        t.setTitleColor(.white, for: .normal)
        t.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        t.backgroundColor = UIColor.phtMidGreen
        t.clipsToBounds = true
        t.layer.cornerRadius = Scale.scaleY(y: 40) / 2
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(sdkBtn)
        sdkBtn.addTarget(self, action: #selector(sdkHandler), for: .touchUpInside)
        sdkBtn.snp.makeConstraints { (make) in
            make.height.equalTo(Scale.scaleY(y: 40))
            make.leading.equalTo(Scale.scaleX(x: 20))
            make.trailing.equalTo(Scale.scaleX(x: -20))
            make.centerY.equalToSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FRSDKStartMonitoring { (isSuccess) in
            if isSuccess {
                let alertController = UIAlertController(title: "i am going to give an alert", message: "message", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                }))
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "there won't be any alert", message: "message", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    func sdkHandler() {
        let vc = FRPhotoCollageCreate(uniqueId: "yangfan liu")
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
}

extension OpenViewController: FRPhotoCollageCreateDelegate {
    func FRDidTapCancel() {
        debugPrint("did tap cancel")
//        self.dismiss(animated: true, completion: nil)
    }
    
    func FRDidTapDone() {
        debugPrint("did tap done")
//        self.dismiss(animated: true, completion: nil)
    }
}

