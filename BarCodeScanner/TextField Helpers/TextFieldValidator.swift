//
//  TextFieldValidator.swift
//  BarCodeScanner
//
//  Created by Manoj Karki on 11/23/20.
//

import Foundation

typealias ValidationResult = (Bool, String?)

enum UserInfoField {

    case fullName
    case email
    case contactNumber
    case customerCode
    case loginPassword
    
    case changePasswordOldPassword
    case changePasswordNewPassword
    case confirmPassword

    var shouldValidateEmpty: Bool {
        return true
    }

    var emptyErrorMessage: String {
        
        switch self {
        case .contactNumber:
            return "Please enter your contact number"
        case .email:
            return "Please enter your email"
        case .fullName:
            return "Please enter your full name"
        case .customerCode:
            return "Please enter your valid IME Customer Code"
        case .loginPassword:
            return "Please enter your password"
        default:
            return ""
        }
    }
    
    var invalidMessage: String {
        
        switch self {
        case .contactNumber:
            return "Please enter valid contact number"
        case .email:
            return "Please enter a valid email address"
        case .fullName:
            return "Please enter valid full name"
        case .customerCode:
            return "Please enter your valid IME Customer Code"
        case .loginPassword:
            return "Password must be at least 6 characters long."
        case .changePasswordNewPassword:
            return "New password must be at least 6 characters long"
        case .changePasswordOldPassword:
            return "Old password must be at least 6 characters long"
        case  .confirmPassword:
            return "Confirm password must be at least 6 characters long"
        }
    }
}


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
