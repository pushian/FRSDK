//
//  PhotoFrame.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 23/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class PhotoFrame: UIImageView {
    
    fileprivate var infoLable: UILabel! = {
        let t = UILabel()
        t.text = "Take one last we-fie before you go! =)"
        t.numberOfLines = 0
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
        t.textColor = UIColor.phtAzure
        t.backgroundColor = .clear
        t.textAlignment = .center
        return t
    }()
    fileprivate var infoLableTwo: UILabel! = {
        let t = UILabel()
        t.text = "Tap to set your photo"
        t.numberOfLines = 0
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.textColor = UIColor.phtAzure
        t.backgroundColor = .clear
        t.textAlignment = .center
        return t
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        contentMode = .scaleAspectFill
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        backgroundColor = UIColor.phtWhite
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 4
        addSubview(infoLable)
        addSubview(infoLableTwo)
        
        infoLable.isHidden = true
        infoLableTwo.isHidden = true
        infoLable.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 11))
            make.trailing.equalTo(Scale.scaleX(x: -11))
            make.center.equalToSuperview()
        }
        infoLableTwo.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 11))
            make.trailing.equalTo(Scale.scaleX(x: -11))
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func noImage(withLabelOne: Bool = true) {
        if withLabelOne {
            infoLable.isHidden = false
            infoLableTwo.isHidden = true
        } else {
            infoLableTwo.isHidden = false
            infoLable.isHidden = true
        }
    }
    
    func gotImage() {
        infoLable.isHidden = true
        infoLableTwo.isHidden = true
    }
}
