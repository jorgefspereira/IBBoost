//
//  IBBCorner.swift
//  IBBoost
//
//  Created by Jorge Pereira on 26/09/2017.
//

import UIKit

public protocol IBBCorner {
    var cornerRadius: CGFloat { get set }
    var cornerCircle: Bool { get set }
}

public extension IBBCorner where Self: UIView {
    
    public func setupCorner() {
        let cornerRadius: CGFloat
        
        if self.cornerCircle {
            cornerRadius = self.frame.size.height / 2
        } else {
            cornerRadius = self.cornerRadius
        }
        
        if cornerRadius.isNaN || cornerRadius <= 0 {
            return
        }
        
        self.layer.cornerRadius = cornerRadius
    }
}
