//
//  TextFieldValidator.swift
//  BarCodeScanner
//
//  Created by Manoj Karki on 11/23/20.
//

import Foundation

typealias ValidationResult = (Bool, String?)

struct TextFieldValidator {
    
    func validate(type: UserInfoField, text: String) -> ValidationResult  {
        
        if type.shouldValidateEmpty && text.isEmpty {
            return (false, type.emptyErrorMessage)
        }

        switch type {
        case .fullName:
            return (text.isAlphabetOnly, type.invalidMessage)

        case .email:
            return (text.isValidEmail, type.invalidMessage)

        case .contactNumber:
            return (text.replacingDashWithSpace().isNumberOnly, type.invalidMessage)
        case .customerCode:
            return (!text.isEmpty, type.invalidMessage)
        case .loginPassword:
            return (text.count >= 6, type.invalidMessage)
        case .changePasswordOldPassword, .changePasswordNewPassword, .confirmPassword:
            return (text.count >= 6, type.invalidMessage)
        }
    }
}
