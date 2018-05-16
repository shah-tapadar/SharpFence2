//
//  UIView+Custom.swift
//  TollbuddyFrameworkSample
//
//  Created by Dhanesh V on 5/14/18.
//  Copyright © 2018 HTA. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let layerBorderColor = layer.borderColor {
                return UIColor(cgColor:layerBorderColor)
            } else {
                return UIColor.black
            }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
