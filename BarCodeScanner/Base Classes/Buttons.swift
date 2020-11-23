//
//  Buttons.swift
//  IME Motors
//
//  Created by Manoj Karki on 4/27/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//

import Foundation
import UIKit

class StandardInsetButton : UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 40.0, bottom: 0.0, right: 40.0)
        self.titleLabel?.font = IMFont.init(.semiBold, size: .standard(.size14)).instance
        self.titleLabel?.textColor = .white
        
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.white, for: .highlighted)
        
        self.backgroundColor = IMColor.redThemeColor.value
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rounded()
        
        self.titleLabel?.textColor = .white
        self.titleLabel?.font =  IMFont.init(.semiBold, size: .standard(.size14)).instance
    }
    
}

class StandardInsetButtonWide : UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 90.0, bottom: 0.0, right: 90.0)
    
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.white, for: .highlighted)
    
        self.backgroundColor = IMColor.redThemeColor.value

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        rounded()
        self.titleLabel?.textColor = .white
        self.titleLabel?.font =  IMFont.init(.semiBold, size: .standard(.size14)).instance
    }

}

class StandardButtonLight : UIButton {

    override func awakeFromNib() {

        super.awakeFromNib()
        contentEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 18.0, bottom: 0.0, right: 18.0)
        
        self.setTitleColor(IMColor.redThemeColor.value, for: .normal)
        self.setTitleColor(IMColor.redThemeColor.value, for: .highlighted)
        
        self.backgroundColor = IMColor.offWhiteBackground.value
        self.tintColor = IMColor.redThemeColor.value
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        rounded()
        
        self.titleLabel?.textColor = IMColor.redThemeColor.value
        self.titleLabel?.font =  IMFont.init(.medium, size: .standard(.size12)).instance
    }
    
}

// Example: forgot your password? in login screen

class TextButtonBlack: UIButton {
    
    override func awakeFromNib() {

        super.awakeFromNib()

        self.setTitleColor(.black, for: .normal)
        self.setTitleColor(.black, for: .highlighted)
        
        self.backgroundColor = .white
        self.tintColor = .black
        
        self.titleLabel?.font =  IMFont.init(.regular, size: .standard(.size12)).instance
        self.contentMode = .center
    }
    
}

// Example: Login with customer code button in login screen

class TextButtonBordered: UIButton {
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.setTitleColor(.black, for: .normal)
        self.setTitleColor(.black, for: .highlighted)
        
        self.backgroundColor = .white
        self.tintColor = .black
        
        self.titleLabel?.font =  IMFont.init(.semiBold, size: .standard(.size12)).instance
        self.contentMode = .center
        
        self.set(borderWidth: 1.0)
        self.set(borderColor: IMColor.navSeparatorColor.value)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.rounded()
    }

}

class TextButtonUnderlined: UIButton {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.setTitleColor(UIColor.black.withAlphaComponent(0.80), for: .normal)
        self.setTitleColor(UIColor.black.withAlphaComponent(0.50), for: .highlighted)
        
        self.backgroundColor = .white
        self.tintColor = .black
        
        self.titleLabel?.font =  IMFont.init(.semiBold, size: .standard(.size12)).instance
        self.contentMode = .center
    }
    
    func setUnderlinedTitle(titleTxt: String) {
        
        let attributes = [NSAttributedString.Key.underlineColor: UIColor.black, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        
        self.setAttributedTitle(NSAttributedString.init(string: titleTxt, attributes: attributes), for: .normal)
        
        self.setAttributedTitle(NSAttributedString.init(string: titleTxt, attributes: attributes), for: .highlighted)
        
    }
    
}


