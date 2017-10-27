//
//  BaseViewController.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 21/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var navView: UIView! = {
        let t = UIView()
        t.backgroundColor = .white
        return t
    }()
    var leftBtn: UIImageView! = {
        let t = UIImageView()
        t.FRApplyBundleImage(name: "leftArrow")
        t.contentMode = .left
        t.isUserInteractionEnabled = true
//        t.setImage(UIImage.getBundleImage(name: "leftArrow"), for: .normal)
        return t
    }()
    var rightBtn: UIButton! = {
        let t = UIButton()
        t.setTitleColor(UIColor.phtAzure, for: .normal)
        t.titleLabel?.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
        return t
    }()
    var titleLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
        t.textColor = UIColor.black
        return t
    }()
    
    var statusBarHeight: CGFloat = 20
    var navigationBarHeight: CGFloat = 44
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton

        statusBarHeight = UIApplication.shared.statusBarFrame.height
        navigationBarHeight = (navigationController?.navigationBar.frame.height) ?? 44
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        HttpClient.sharedInstance.delegate = self

        view.addSubview(navView)
        navView.addSubview(leftBtn)
        navView.addSubview(titleLabel)
        navView.addSubview(rightBtn)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(leftHandler))
        leftBtn.addGestureRecognizer(gesture)
        rightBtn.addTarget(self, action: #selector(rightHandler), for: .touchUpInside)
        
        navView.snp.makeConstraints { (make) in
            make.top.equalTo(statusBarHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(navigationBarHeight)
        }
        leftBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
//            make.leading.equalTo(Scale.scaleX(x: 13))
            make.leading.equalTo(Scale.scaleX(x: 15))
            make.width.equalTo(Scale.scaleX(x: 76))
            make.height.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        rightBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalTo(Scale.scaleX(x: Scale.scaleX(x: -13)))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setRightBtn(title: String) {
        rightBtn.setTitle(title, for: .normal)
    }
    func setTitle(title: String) {
        titleLabel.text = title
    }
    func leftHandler() {
        
    }
    func rightHandler() {
        
    }
    
}
