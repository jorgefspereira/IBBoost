//
//  IBBButton.swift
//  IBBoost
//
//  Created by Jorge Pereira on 27/09/2017.
//

import UIKit

@IBDesignable open class IBBButton: UIButton, IBBCorner, IBBShadow, IBBBackground, IBBBorder, IBBText {
    
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
    
    @IBInspectable open var insetTop: CGFloat = 0
    @IBInspectable open var insetBottom: CGFloat = 0
    @IBInspectable open var insetLeft: CGFloat = 0
    @IBInspectable open var insetRight: CGFloat = 0
    
    // Update storyboard view
    //
    open override func prepareForInterfaceBuilder()
    {
        self.setNeedsLayout()
        
        if let text = self.titleLabel?.text, text.characters.count > 0
        {
            self.titleLabel?.attributedText = self.createAttributedString(text: text, font: self.titleLabel!.font)
        }
    }
    
    open override func layoutSubviews()
    {
        super.layoutSubviews()
        self.setupCorner()
        self.setupShadow()
        self.setupBackground()
        self.setupBorder()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.setupText()
    }
    
    fileprivate func setupText()
    {
        let controlStates : [UIControlState] = [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved]
        
        for state in controlStates
        {
            if let text = self.title(for: state), text.characters.count > 0
            {
                let attributedString = self.createAttributedString(text: text, font: self.titleLabel!.font)
                self.setAttributedTitle(attributedString, for: state)
            }
        }
    }
}

