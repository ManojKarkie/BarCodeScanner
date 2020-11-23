//
//  ColorHelper.swift
//  IME Motors
//
//  Created by Manoj Karki on 4/27/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//

import Foundation
import UIKit

enum IMColor {

    case redThemeColor
    
    case offWhiteBackground
    
    case titleColorDark
    
    case darkGrayThemeColor
    
    case descLabelColorDark
    
    case navSeparatorColor
    
    case lightTextColor
    
    case themeLight
    case border
    case shadow
    case separatorDark
    
    case brightRed
    case brightBlue
    case rouge
    case lightPink
    case veryLightPink

    case darkBackground
    case lightBackground
    case intermidiateBackground

    case darkText
    case intermediateDarkText
    case lightText
    case intermidiateText
    
    case affirmation
    case negation
    case textFieldText
    case textFieldLineActive
    case textFieldPlacholderNormal
    case textFieldErrorColor
    case textFieldLineNormal

    case denoBorderColor
    case custom(hexString: String, alpha: Double)

    
    // NEW THEME
    
    case brightRedPrimary
    
}

extension IMColor {

    var value: UIColor {

        var instanceColor = UIColor.clear
        switch self {
        
        case .navSeparatorColor:
            instanceColor = UIColor(hexString: "#E8E8E8")
            
        case .border:
            instanceColor = UIColor(hexString: "#333333")
            
        case .darkGrayThemeColor:
            instanceColor = UIColor.init(hexString: "#78797A")
        
        case .redThemeColor:
            instanceColor = UIColor(hexString: "#E50019")
            
        case .offWhiteBackground:
            instanceColor = UIColor.init(hexString: "#F3F4F7")
            
        case .titleColorDark:
              instanceColor = UIColor(hexString: "#171717")
            
        case .descLabelColorDark:
            instanceColor = UIColor(hexString: "#000000").withAlphaComponent(0.66)
            
        case .themeLight:
            instanceColor = UIColor(red: 255/255, green: 171/255, blue: 173/255, alpha: 1.0)
        case .shadow:
            instanceColor = UIColor(hexString: "#cccccc")
        case .darkBackground:
            instanceColor = UIColor(hexString: "#999966")
        case .lightBackground:
            instanceColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0)
        case .intermidiateBackground:
            instanceColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        case .darkText:
            instanceColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1)
        case .intermidiateText:
            instanceColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.0)
        case .lightText:
            instanceColor =  UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.0)
        case .affirmation:
            instanceColor = UIColor(hexString: "#00ff66")
        case .negation:
            instanceColor = UIColor(hexString: "#ff3300")
        case .intermediateDarkText:
            instanceColor  = UIColor(red: 0.26, green: 0.26, blue: 0.26, alpha: 1.0)

           
        //TEXTFIELD THEME
            
        case .textFieldText:
            instanceColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
        case .textFieldLineActive:
            
            instanceColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.0)
        
        case .textFieldLineNormal:
            instanceColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
            
        case .textFieldPlacholderNormal:
            instanceColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
        
        case .textFieldErrorColor:
            instanceColor = UIColor(red: 244/255, green: 50/255, blue: 41/255, alpha: 1.0)
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
            
        case .separatorDark:
            instanceColor = UIColor(hexString: "#E6E6E6")
        case .denoBorderColor:
            instanceColor = UIColor(red: 241/255, green: 126/255, blue: 129/255, alpha: 1.0)
        case .brightRed:
            instanceColor = UIColor(red: 237.0 / 255.0, green: 28.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
        case .brightBlue:
            instanceColor =  UIColor.init(hexString: "#0000FF")
        case .rouge:
            instanceColor = UIColor.init(hexString: "#9c272d")
        case .lightPink:
            instanceColor = UIColor.init(hexString: "#fceaea")
        case .veryLightPink:
            instanceColor = UIColor.init(hexString: "#fff4f4")
            
        case .brightRedPrimary:
            return UIColor.init(hex: "#E92429")
        case .lightTextColor:
            return UIColor.init(hex: "#515C6F").withAlphaComponent(0.5)
        }
        return instanceColor
    }
}

