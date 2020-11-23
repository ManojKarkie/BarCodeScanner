//
//  LoginAPIDataManager.swift
//  IME Motors
//
//  Created Manoj Karki on 5/19/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//
//

import UIKit

class LoginAPIDataManager: LoginAPIDataManagerInputProtocol {

    init() {}
    
    // Data fetch service methods goes here
    func authExternalLogin(params: [String : String], onSuccess: ((Token?) -> Void)?, onError: ((String?) -> Void)?) {
        ApiFetcher.fetch(UserApi.authExternalLogin(params: params), success: { (response: ApiResponse<Token>) -> Void in
            onSuccess?(response.responseData)
        }) { (errorMessage, error) in
            onError?(errorMessage)
        }
    }

    func login(params: [String : String], onSuccess: ((TokenResult?) -> Void)?, onError: ((String?) -> Void)?) {
        
        ApiFetcher.fetch(UserApi.login(params: params), success: { (response: ApiResponse<LoginResponse>) -> Void in
            
            let tokenResult = response.responseData?.token
            onSuccess?(tokenResult)
            
        }) { (errorMessage, error) in
            onError?(errorMessage)
        }
    }

    func verifyCustomerCode(params: [String : String], onSuccess: ((NavCustomerDetail?) -> Void)?, onError: ((String?) -> Void)?) {
        
        ApiFetcher.fetch(UserApi.verifyCustomerCode(params: params), success: { (response: ApiResponse<NavCustomerDetail>) -> Void in
            onSuccess?(response.responseData)
        }) { (errorMessage, error) in
            onError?(errorMessage)
        }
    }

    func loginWithCustomerCode(params: [String : String], onSuccess: ((Token?) -> Void)?, onError: ((String?) -> Void)?) {

        ApiFetcher.fetch(UserApi.customerCodeLogin(params: params), success: { (response: ApiResponse<Token>) -> Void in
            onSuccess?(response.responseData)
        }) { (errorMessage, error) in
            onError?(errorMessage)
        }
    }

}
