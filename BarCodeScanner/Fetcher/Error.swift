//
//  File.swift
//
//  Created by Manoj Karki on 6/10/20.
//

import Foundation
import Moya

enum ApiError: Error {
    case moyaError(error: MoyaError)
    case unauthorized
    case apiErrorCode(description: String?)
    case unknown
}
 
extension ApiError: LocalizedError {

    var errorDescription: String? {

        switch self {
        case let .moyaError(error):
            return NSLocalizedString(error.localizedDescription, comment: "")
       
        case .unauthorized:
            return  NSLocalizedString("Session Expired, Please login", comment: "")
        
        case let .apiErrorCode(description):
            return NSLocalizedString(description ?? "", comment: "")
        
        case .unknown:
            return  NSLocalizedString("Something went wrong, please try later", comment: "")
        }
    }

}
