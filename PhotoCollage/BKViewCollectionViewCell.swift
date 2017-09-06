//
//  BKViewCollectionViewCell.swift
//  PhotoCollage
//
//  Created by Yangfan Liu on 22/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import AlamofireImage

class BKViewCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "bkViewCollectionViewCell"
    
    var bkImageView: UIImageView! = {
        let t = UIImageView()
        t.backgroundColor = UIColor.white
        t.contentMode = .scaleAspectFill
        t.clipsToBounds = true
        t.layer.cornerRadius = 6
        return t
    }()
    
    var overlay: UIView! = {
        let t = UIView()
        t.backgroundColor = .white
        t.alpha = 0.4
        return t
    }()
    
    var selectedView: UIImageView! = {
        let t = UIImageView()
//        t.image = #imageLiteral(resourceName: "selectedIcon")
        t.FRApplyBundleImage(name: "selectedIcon")
        t.contentMode = .scaleAspectFit
        return t
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        contentView.addSubview(bkImageView)
        bkImageView.addSubview(overlay)
        bkImageView.addSubview(selectedView)
        getUnselected()
        setConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(image: Any?) {
        if let image = image as? UIImage {
            bkImageView.image = image
        } else if let image = image as? String {
            let size = CGSize(width: Scale.scaleY(y: 89), height: Scale.scaleY(y: 89))
            bkImageView.af_setImage(
                withURL: NSURL(string: image)! as URL,
                placeholderImage: UIImage(),
                filter: AspectScaledToFillSizeFilter(size: size),
                imageTransition: .crossDissolve(Constants.imageLoadTime)
            )
        }
    }
    
    func setConstraint() {
        bkImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        overlay.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        selectedView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(Scale.scaleX(x: 19.1))
            make.height.equalTo(Scale.scaleY(y: 17.4))
        }
    }
    
    func getSelected() {
        overlay.isHidden = false
        selectedView.isHidden = false
    }
    
    func getUnselected() {
        overlay.isHidden = true
        selectedView.isHidden = true
    }
    
}
