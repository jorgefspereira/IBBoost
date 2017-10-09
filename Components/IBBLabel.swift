//
//  IBBLabel.swift
//  IBBoost
//
//  Created by Jorge Pereira on 27/09/2017.
//

import UIKit

@IBDesignable open class IBBLabel: UILabel, IBBBorder, IBBText {
    
    @IBInspectable open var borderWidth: CGFloat = CGFloat.nan
    @IBInspectable open var borderColor: UIColor? = nil
    @IBInspectable open var borderTop: Bool = false
    @IBInspectable open var borderBottom: Bool = false
    @IBInspectable open var borderLeft: Bool = false
    @IBInspectable open var borderRight: Bool = false
    
    @IBInspectable open var insetTop: CGFloat = 0
    @IBInspectable open var insetBottom: CGFloat = 0
    @IBInspectable open var insetLeft: CGFloat = 0
    @IBInspectable open var insetRight: CGFloat = 0
    
    // Update storyboard view
    //
    open override func prepareForInterfaceBuilder()
    {
        self.setNeedsLayout()
        self.setupText()
    }
    
    open override func layoutSubviews()
    {
        super.layoutSubviews()
        self.setupBorder()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.setupText()
    }
    
    open override func drawText(in rect: CGRect)
    {
        let insets = UIEdgeInsets(top: self.insetTop, left: self.insetLeft, bottom: self.insetBottom, right: self.insetRight)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    fileprivate func setupText()
    {
        if let wText = self.text, wText.characters.count > 0
        {
            self.attributedText = self.createAttributedString(text: wText, font: self.font)
        }
    }
}


