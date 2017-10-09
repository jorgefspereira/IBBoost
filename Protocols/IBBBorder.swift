//
//  IBBBorder.swift
//  IBBoost
//
//  Created by Jorge Pereira on 27/09/2017.
//

import UIKit

public protocol IBBBorder {
    var borderWidth: CGFloat { get set }
    var borderColor: UIColor? { get set }
    var borderTop: Bool { get set }
    var borderBottom: Bool { get set }
    var borderLeft: Bool { get set }
    var borderRight: Bool { get set }
}

public extension IBBBorder where Self: UIView {
    
    public func setupBorder() {
        if self.borderWidth.isNaN || self.borderWidth <= 0 || self.borderColor == nil {
            return
        }
        
        self.removeExistingBorderLayer()
        self.createBorderLayer()
    }
    
    fileprivate func removeExistingBorderLayer() {
        self.layer.sublayers?.forEach({ layer in
            if layer.name == "IBBBorderLayer" {
                layer.removeFromSuperlayer()
            }
        })
    }
    
    fileprivate func createBorderLayer() {
        
        let borderLayer = CALayer()
        borderLayer.name = "IBBBorderLayer"
        borderLayer.borderWidth = self.borderWidth
        borderLayer.borderColor = self.borderColor!.cgColor
        
        var frame = self.bounds
        
        if !self.borderLeft {
            frame.origin.x -= 1000
            frame.size.width += 1000
        }
        
        if !self.borderTop {
            frame.origin.y -= 1000
            frame.size.height += 1000
        }
        
        if !self.borderBottom {
            frame.size.height += 1000
        }
        
        if !self.borderRight {
            frame.size.width += 1000
        }
        
        borderLayer.frame = frame
        borderLayer.cornerRadius = self.layer.cornerRadius
        
        let mask = CALayer()
        mask.frame = CGRect(x: -frame.origin.x, y: -frame.origin.y, width: self.bounds.width, height: self.bounds.height)
        mask.backgroundColor = UIColor.white.cgColor
        mask.cornerRadius = self.layer.cornerRadius
        borderLayer.mask = mask
        
        
        self.layer.addSublayer(borderLayer)
    }
}
