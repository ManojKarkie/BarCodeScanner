//
//  FontHelper.swift
//  IME Motors
//
//  Created by Manoj Karki on 4/27/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//

import Foundation
import UIKit

struct IMFont {

    enum FontName: String {

        case bold = "WorkSans-Bold"
        case boldItalic = "WorkSans-BoldItalic"
        case heavy = "WorkSans-Heavy"
        case heavyItalic = "WorkSans-HeavyItalic"
        case light = "WorkSans-Light"
        case lightItalic = "WorkSans-LightItalic"
        case medium = "WorkSans-Medium"
        case mediumItalic = "WorkSans-MediumItalic"
        case regular = "WorkSans-Regular"
        case regualrItalic = "WorkSans-RegularItalic"
        case semiBold = "WorkSans-SemiBold"
        case semiBoldItalic = "WorkSans-SemiboldItalic"

    }

    enum FontType {
        case system
        case installed(FontName)
        case custom(String)
    }

    enum FontSize {

        case standard(StandardSize)
        case custom(Double)

        var value: Double {
            switch self {
            case .standard(let size):
                return size.rawValue
            case .custom(let value):
                return value
            }
        }

    }

    enum StandardSize: Double {
        case size12 = 12.0
        case h2 = 18.0
        case h3 = 16.0
        case size14 = 14.0
        case h5 = 13.0
        case h5Small = 11.0
        case h6 = 10.0
        case h7 = 8.0
        case buttonTitle = 15.0

        case size24 = 24.0
    }

    var fontType: String
    var fontSize: FontSize

    init(_ fontType: FontName, size: FontSize) {
        self.fontType = fontType.rawValue
        self.fontSize = size
    }
}

extension IMFont {

    var instance: UIFont {

        guard let font =  UIFont(name: fontType, size: CGFloat(fontSize.value)) else {
            fatalError("\(fontType) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
        }
        
        return font
   }
}


