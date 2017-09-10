//
//  ViewController.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 21/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class OpenViewController: BaseViewController {

    fileprivate var sdkBtn: UIButton! = {
        let t = UIButton()
        t.setTitle("SDK Test", for: .normal)
        t.setTitleColor(.white, for: .normal)
        t.titleLabel?.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 12))
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

