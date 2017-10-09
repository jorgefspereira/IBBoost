//
//  IBBText.swift
//  IBBoost
//
//  Created by Jorge Pereira on 27/09/2017.
//

import UIKit

public protocol IBBText {
    var insetTop: CGFloat { get set }
    var insetLeft: CGFloat { get set }
    var insetBottom: CGFloat { get set }
    var insetRight: CGFloat { get set }
}

public extension IBBText where Self: UIView {
    
    func createAttributedString(text: String, font: UIFont) -> NSMutableAttributedString
    {
        let attString = NSMutableAttributedString(string:text)
        
        do {
            let pattern = "<font([^>]*)>([^<]*)</font>"
            let regex   = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)    
            
            while let result = regex.firstMatch(in: attString.string, options: [], range: NSMakeRange(0, attString.string.characters.count))
            {
                let indexMain       = result.range(at: 0)
                let indexAttributes = result.range(at: 1)
                let indexContent    = result.range(at: 2)
                
                let patternSize = "size=\"([^\"]*)\""
                let regexSize   = try NSRegularExpression(pattern: patternSize, options: .caseInsensitive)
                var size        = font.pointSize
                
                if let resultSize = regexSize.firstMatch(in: attString.string, options:[], range: indexAttributes)
                {
                    let index     = resultSize.range(at: 1)
                    let substring = NSString(string:attString.string).substring(with: index)
                    
                    if let n = NumberFormatter().number(from: substring)
                    {
                        size = CGFloat(truncating: n)
                    }
                }
                
                let patternFont = "name=\"([^\"]*)\""
                let regexFont   = try NSRegularExpression(pattern: patternFont, options: .caseInsensitive)
                
                if let resultFont = regexFont.firstMatch(in: attString.string, options:[], range: indexAttributes)
                {
                    let index      = resultFont.range(at: 1)
                    let substring  = NSString(string:attString.string).substring(with: index)
                    
                    if let font = UIFont(name: substring, size: size)
                    {
                        attString.addAttribute(NSAttributedStringKey.font, value: font, range: indexMain)
                    }
                }
                
                
                let patternAlignment = "alignment=\"([^\"]*)\""
                let regexAlignment  = try NSRegularExpression(pattern: patternAlignment, options: .caseInsensitive)
                
                if let resultAlignment = regexAlignment.firstMatch(in: attString.string, options:[], range: indexAttributes)
                {
                    let index      = resultAlignment.range(at: 1)
                    let substring  = NSString(string:attString.string).substring(with: index)
                    var alignment: NSTextAlignment? = nil
                    
                    switch (substring.lowercased())
                    {
                    case "left":
                        alignment = .left
                    case "right":
                        alignment = .right
                    case "center":
                        alignment = .center
                    case "justified":
                        alignment = .justified
                    case "natural":
                        alignment = .natural
                    default:
                        break
                    }
                    
                    if let auxAlignment = alignment
                    {
                        let paragraphStyle          = NSMutableParagraphStyle()
                        paragraphStyle.alignment    = auxAlignment
                        attString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: indexMain)
                    }
                }
                
                let patternColor = "color=\"([^\"]*)\""
                let regexColor   = try NSRegularExpression(pattern: patternColor, options: .caseInsensitive)
                
                if let resultColor = regexColor.firstMatch(in: attString.string, options:[], range: indexAttributes)
                {
                    let index      = resultColor.range(at: 1)
                    let substring  = NSString(string:attString.string).substring(with: index)
                    
                    let color = UIColor(hexString: substring)
                    
                    attString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: indexMain)
                }
                
                let patternOptions  = "options=\"([^\"]*)\""
                let regexOptions    = try NSRegularExpression(pattern: patternOptions, options: .caseInsensitive)
                
                if let resultOptions = regexOptions.firstMatch(in: attString.string, options:[], range: indexAttributes)
                {
                    let index = resultOptions.range(at: 1)
                    let substring = NSString(string:attString.string).substring(with: index)
                    
                    let patternUnderline = "underline"
                    if substring.range(of: patternUnderline, options: .caseInsensitive) != nil
                    {
                        attString.addAttribute(NSAttributedStringKey.underlineStyle, value:NSNumber(value: NSUnderlineStyle.styleSingle.rawValue as Int), range: indexMain)
                    }
                }
                
                let patternTabStops = "tabStops=\"([^\"]*)\""
                let regexTabStops   = try NSRegularExpression(pattern: patternTabStops, options: .caseInsensitive)
                
                if let resultTabStops = regexTabStops.firstMatch(in: attString.string, options:[], range: indexAttributes)
                {
                    let index       = resultTabStops.range(at: 1)
                    let substring   = NSString(string:attString.string).substring(with: index)
                    
                    if let tabStops = Int(substring), tabStops > 0
                    {
                        let tabWidth        = self.frame.size.width / CGFloat(tabStops)
                        let paragraphStyle  = NSMutableParagraphStyle()
                        var arrayTabStops: [NSTextTab] = []
                        
                        for i in 1 ... tabStops
                        {
                            var textAlignment: NSTextAlignment = .left
                            if ((tabStops/2) == i) {
                                textAlignment = .center
                            }
                            else if (i > (tabStops/2)){
                                textAlignment = .right
                            }
                            
                            let tab = NSTextTab(textAlignment: textAlignment, location: (tabWidth * CGFloat(i)), options:[:])
                            arrayTabStops.append(tab)
                        }
                        
                        paragraphStyle.tabStops = arrayTabStops
                        attString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: indexMain)
                    }
                }
                
                let substring = NSString(string:attString.string).substring(with: indexContent)
                attString.replaceCharacters(in: indexMain, with: substring)
            }
            
        }
        catch {
            print("[IBBOOST] - IBBTEXT ::: REGULAR EXPRESSION EXCEPTION")
        }
        
        return attString
    }
    
}
