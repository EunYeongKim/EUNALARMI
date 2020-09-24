//
//  CollectionViewcelllExtension.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/24.
//  Copyright © 2020 60080252. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    func setShadow(cornerRadius: CGFloat, shadowRadius: CGFloat, shadowOpacity: Float, shadowOffsetWidth: CGFloat, shadowOffsetHeight: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        
        layer.cornerRadius = cornerRadius
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:contentView.layer.cornerRadius).cgPath
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
    }
    
    func setBorderRound(cornerRadius: CGFloat) {
        backgroundColor = UIColor.white
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}
