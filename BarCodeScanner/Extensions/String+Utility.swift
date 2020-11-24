//
//  String+Utility.swift
//
//  Created by Manoj Karki on 9/6/17.
//

import Foundation

// String Utilities

fileprivate let currenncyPrefix = "Rs. "

extension String {

    func removingCurrencyPrefix() -> String? {
        if self.contains(currenncyPrefix) {
           return self.replacingOccurrences(of: currenncyPrefix, with: "")
        }
        return self.replacingOccurrences(of: "Rs.", with: "")
    }

    func withCurrencyPrefix() -> String {
        return currenncyPrefix + self
    }
    
    func removingUnderscoreDelimiter() -> String {
       return self.replacingOccurrences(of: "_", with: " ")
    }

    var replacingSpaceWithUnderscore: String {
         return self.replacingOccurrences(of: " ", with: "_")
    }

    func replacingDashWithSpace() -> String {
        return self.replacingOccurrences(of: "-", with: " ")
    }
    
    func replacingSpaceWithDash() -> String {
        return self.replacingOccurrences(of: " ", with: "-")
    }

    func removingComma() -> String {
        return self.replacingOccurrences(of: ",", with: "")
    }

    func removingCountryCode() -> String {
        return self.replacingOccurrences(of: "+977", with: "").replacingOccurrences(of: "+977 ", with: "")
    }

    func reversingNepaliDateString() -> String {

        let components = self.components(separatedBy: " ")

        if components.count != 3 {
            return self
        }

        if let firstComponent = components.first, firstComponent.count > 2, let lastComponent = components.last {


            let middleComponent = components[1]

            let reversedNepaliDateString = lastComponent + " " + middleComponent + " " +  firstComponent

            return reversedNepaliDateString
        }
        return self
    }

    var onlyAlphanumeric: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return self.filter {okayChars.contains($0) }
    }
    
    func removingSpace() -> String {
       return self.replacingOccurrences(of: " ", with: "")
    }
    
    var cleanMobileNumber: String {
        return self.removingSpace().removingCountryCode().replacingOccurrences(of: "-", with: "")
    }
}

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.index(self.startIndex, offsetBy: from))
    }
}

extension String {

    var isInteger: Bool {
        guard let _ = Int(self) else {
            return false
        }
        return true
    }

    
    var removingDecimalPoints: String {

        if (self.contains(".") || self.contains(".")) {
            
            if let absoluteValue =  self.components(separatedBy: ".").first {
                return absoluteValue
            }
        }
        return self
    }

    var isValidEmail:Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidMobileNumberPrefix: Bool {

        let first2 = String(self.prefix(3))
  
        return first2 == "984" || first2 == "986" || first2 == "985" || first2 == "980" || first2 == "981" || first2 == "982"
            || first2 == "961" || first2 == "988" || first2 == "962" || first2 == "974" || first2 == "975"
    }


   

    var removingLeadingZeros: String {
        if let intString = Int(self) {
            return "\(intString)"
        }
        return ""
    }


    var isAlphabetOnly:Bool {
        let alphabetOnlyRegex = "^[A-z ]+$"
        let alphabetTest = NSPredicate(format:"SELF MATCHES %@", alphabetOnlyRegex)
        return alphabetTest.evaluate(with: self)
    }

    var isNumberOnly : Bool {
        let alphabetOnlyRegex = "^[0-9 ]+$"
        let alphabetTest = NSPredicate(format:"SELF MATCHES %@", alphabetOnlyRegex)
        return alphabetTest.evaluate(with: self)
    }


    var isAlphaNumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }

    var isADDateString: Bool {
        return self.contains("-")
    }

    var containsSpaceBetweenTwo: Bool {
        return self.components(separatedBy: " ").count == 2
    }

    var containsDashes : Bool {
        return self.components(separatedBy: "-").count > 1
    }
    
    var base64EncodedData: Data? {
        let data = self.data(using: .utf8)
        let base64Data = data?.base64EncodedData(options: Data.Base64EncodingOptions(rawValue: 0))
        return base64Data
    }
    
    var containsSpace: Bool {
        return self.components(separatedBy: " ").count > 0
    }
    
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

}



//var htmlToAttributedString: NSAttributedString? {
//    guard
//        let data = data(using: String.Encoding.utf8)
//        else { return nil }
//    do {
//        return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:String.Encoding.utf8], documentAttributes: nil)
//    } catch let error as NSError {
//        print(error.localizedDescription)
//        return  nil
//    }
//}
//var htmlToString: String {
//    return htmlToAttributedString?.string ?? ""
//    }
//}
