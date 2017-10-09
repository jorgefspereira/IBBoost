//
//  IBBBackground.swift
//  IBBoost
//
//  Created by Jorge Pereira on 27/09/2017.
//

import UIKit

public protocol IBBBackground {
    var startColor: UIColor? { get set }
    var endColor: UIColor? { get set }
    var startPoint: CGPoint { get set }
    var endPoint: CGPoint { get set }
}

public extension IBBBackground where Self: UIView {
    
    public func setupBackground()
    {
        self.removeExistingGradientLayer()
        
        if self.startColor != nil && self.endColor != nil {
            self.createGradientLayer()
        }
    }
    
    fileprivate func removeExistingGradientLayer()
    {
        self.layer.sublayers?.forEach({ layer in
            if layer.name == "IBBGradientLayer" {
                layer.removeFromSuperlayer()
            }
        })
    }
    
    fileprivate func createGradientLayer()
    {
        let layer           = CAGradientLayer()
        layer.name          = "IBBGradientLayer"
        layer.frame         = self.bounds
        layer.startPoint    = self.startPoint
        layer.endPoint      = self.endPoint
        layer.colors        = [self.startColor!.cgColor, self.endColor!.cgColor]
        layer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(layer, at: 0)
    }
    
    fileprivate func updateColors()
    {
        if let sublayers = self.layer.sublayers
        {
            for sublayer in sublayers
            {
                if sublayer.isKind(of: CAGradientLayer.self)
                {
                    let layer = sublayer as! CAGradientLayer
                    layer.colors = [self.startColor!.cgColor, self.endColor!.cgColor]
                }
            }
        }
    }
}
