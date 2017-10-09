//
//  IBBTextField.swift
//  IBBoost
//
//  Created by Jorge Pereira on 27/09/2017.
//

import UIKit

@IBDesignable open class IBBTextField: UITextField, IBBBorder {
    
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
    
    @IBInspectable open var placeHolderColor: UIColor? = nil
    
    open override func prepareForInterfaceBuilder()
    {
        self.setNeedsLayout()
    }
    
    open override func layoutSubviews()
    {
        super.layoutSubviews()
        self.setupBorder()
        self.setupPlaceholderText()
    }

    // placeholder position
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: self.insetTop, left: self.insetLeft, bottom: self.insetBottom, right: self.insetRight))
    }
    
    // text position
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: self.insetTop, left: self.insetLeft, bottom: self.insetBottom, right: self.insetRight))
    }
    
    
    fileprivate func setupPlaceholderText()
    {
        if let phColor = self.placeHolderColor,
           let phText = self.placeholder
        {
            self.attributedPlaceholder = NSAttributedString(string: phText, attributes: [NSAttributedStringKey.foregroundColor: phColor])
        }
    }
}
