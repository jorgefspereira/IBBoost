//
//  IBBView.swift
//  IBBoost
//
//  Created by Jorge Pereira on 27/09/2017.
//

import UIKit

@IBDesignable open class IBBView: UIView, IBBCorner, IBBShadow, IBBBackground, IBBBorder {
    
    @IBInspectable open var borderWidth: CGFloat = CGFloat.nan
    @IBInspectable open var borderColor: UIColor? = nil
    @IBInspectable open var borderTop: Bool = false
    @IBInspectable open var borderBottom: Bool = false
    @IBInspectable open var borderLeft: Bool = false
    @IBInspectable open var borderRight: Bool = false
    
    @IBInspectable open var startColor: UIColor? = nil
    @IBInspectable open var endColor: UIColor? = nil
    
    @IBInspectable open var startPoint: CGPoint = CGPoint.zero
    @IBInspectable open var endPoint: CGPoint = CGPoint.zero
    
    @IBInspectable open var cornerRadius: CGFloat = CGFloat.nan
    @IBInspectable open var cornerCircle: Bool = false
    
    @IBInspectable open var shadowColor: UIColor? = nil
    @IBInspectable open var shadowRadius: CGFloat = CGFloat.nan
    @IBInspectable open var shadowOpacity: CGFloat = CGFloat.nan
    @IBInspectable open var shadowOffset: CGPoint = CGPoint(x: CGFloat.nan, y: CGFloat.nan)
    
    open override func prepareForInterfaceBuilder()
    {
        self.setNeedsLayout()
    }
    
    open override func layoutSubviews()
    {
        super.layoutSubviews()
        self.setupCorner()
        self.setupShadow()
        self.setupBackground()
        self.setupBorder()
    }
}


