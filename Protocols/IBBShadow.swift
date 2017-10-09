//
//  IBBShadow.swift
//  IBBoost
//
//  Created by Jorge Pereira on 26/09/2017.
//

import Foundation

import UIKit

public protocol IBBShadow {
    var shadowColor: UIColor? { get set }
    var shadowRadius: CGFloat { get set }
    var shadowOpacity: CGFloat { get set }
    var shadowOffset: CGPoint { get set }
}

public extension IBBShadow where Self: UIView {
    
    public func setupShadow() {
        guard let shadowColor = self.shadowColor else {
            return
        }
        
        self.layer.shadowColor = shadowColor.cgColor
        
        if !self.shadowRadius.isNaN && self.shadowRadius > 0 {
            self.layer.shadowRadius = self.shadowRadius
        }
        
        if !self.shadowOpacity.isNaN && self.shadowOpacity >= 0 && self.shadowOpacity <= 1 {
            self.layer.shadowOpacity = Float(self.shadowOpacity)
        } else {
            self.layer.shadowOpacity = 1.0
        }
        
        if !self.shadowOffset.x.isNaN {
            self.layer.shadowOffset.width = self.shadowOffset.x
        }
        
        if !self.shadowOffset.y.isNaN {
            self.layer.shadowOffset.height = self.shadowOffset.y
        }
        
        self.layer.masksToBounds = false
    }
}
