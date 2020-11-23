//
//  MaterialTextField.swift
//  IME Motors
//
//  Created by Manoj Karki on 5/14/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//

import Foundation
import MaterialComponents
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

extension MDCFilledTextField {
    
    var shownPasswordIcon: UIImage? {
        return UIImage(named: "icon_pass_shown")
    }
    
    var hiddenPasswordIcon: UIImage? {
        return UIImage(named: "icon_pass_hidden")
    }

    func setup(label: String, leadingIcon: String) {
        self.labelBehavior = .floats
    
        self.leadingViewMode = .always
        self.trailingViewMode = .always

        self.setFilledBackgroundColor(.clear, for: .normal)
        self.setFilledBackgroundColor(.clear, for: .disabled)
        self.setFilledBackgroundColor(.clear, for: .editing)
        
        self.setUnderlineColor(IMColor.navSeparatorColor.value, for: .disabled)
        self.setUnderlineColor(IMColor.navSeparatorColor.value, for: .normal)
        
        let underLineColorWhenEditing = UIColor.init(hex: "#095DCB").withAlphaComponent(0.8)

        self.setUnderlineColor(underLineColorWhenEditing, for: .editing)
       // self.setUnderlineColor(IMColor.navSeparatorColor.value, for: .editing)

        self.setTextColor(UIColor.black.withAlphaComponent(0.8), for: .normal)
        self.setTextColor(UIColor.black.withAlphaComponent(0.8), for: .editing)
        self.setTextColor(UIColor.black.withAlphaComponent(0.5), for: .disabled)
        
        let floatingLabelColor = "#515C6F"
    
        self.setNormalLabelColor(UIColor.init(hex:floatingLabelColor).withAlphaComponent(0.6), for: .normal)
        self.setNormalLabelColor(UIColor.init(hex:floatingLabelColor).withAlphaComponent(0.6), for: .disabled)
        self.setNormalLabelColor(UIColor.init(hex:floatingLabelColor).withAlphaComponent(0.6), for: .editing)
        
        self.setFloatingLabelColor(UIColor.init(hex:floatingLabelColor).withAlphaComponent(0.6), for: .normal)
        self.setFloatingLabelColor(UIColor.init(hex:floatingLabelColor).withAlphaComponent(0.6), for: .editing)
        self.setFloatingLabelColor(UIColor.init(hex:floatingLabelColor).withAlphaComponent(0.6), for: .disabled)

        self.label.font = IMFont.init(.medium, size: .standard(.size12)).instance
        self.font = IMFont.init(.regular, size: .custom(15.0)).instance
        
        self.label.text = label

        if let _ = UIImage.init(named: leadingIcon) {
            self.leadingView = self.getIconImgView(iconName: leadingIcon)
        }else {
            
        }
            
        self.setLeadingAssistiveLabelColor(IMColor.redThemeColor.value, for: .disabled)
        self.setLeadingAssistiveLabelColor(IMColor.redThemeColor.value, for: .normal)
        self.setLeadingAssistiveLabelColor(UIColor.white, for: .editing)
        self.leadingAssistiveLabel.font = IMFont.init(.regular, size: .custom(10.0)).instance
    }

    private func getIconImgView(iconName: String) -> UIImageView  {
        let imgView = UIImageView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 20.0, height: 20.0))
        imgView.contentMode = .scaleAspectFit
        imgView.backgroundColor = .white
        imgView.image = UIImage.init(named: iconName)
        return imgView
    }

    func setPasswordShowHideToggle() {
//        let rightBtn = UIButton.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 20.0, height: 20.0))
//        rightBtn.contentMode = .scaleAspectFit
//        rightBtn.backgroundColor = .white
//        rightBtn.setImage(self.hiddenPasswordIcon, for: .normal)
//        rightBtn.addTarget(self, action: #selector(self.togglePasswordMode(sender:)), for: .touchUpInside)
//        self.trailingView = rightBtn
    }
    
    @objc private func togglePasswordMode(sender: UIButton) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        let toggleBtn =  self.trailingView as? UIButton
        let iconToSet = self.isSecureTextEntry ? self.hiddenPasswordIcon : self.shownPasswordIcon
        toggleBtn?.setImage(iconToSet, for: .normal)
    }

    func setValidation(info: ValidationResult) {
        if info.0 {
            self.leadingAssistiveLabel.text = ""
            self.setUnderlineColor(IMColor.navSeparatorColor.value, for: .normal)
        }else {
            self.leadingAssistiveLabel.text = info.1
            self.setUnderlineColor(IMColor.navSeparatorColor.value, for: .normal)
        }
    }

}

extension UITextField {
    
    var txt: String {
        return self.text ?? ""
    }
    
}

