//
//  LoginAPIDataManager.swift
//
//  Created Manoj Karki on 5/19/20.
//
//

import Foundation

class LoginAPIDataManager: LoginAPIDataManagerInputProtocol {

    init() {}
    
    // Data fetch service methods goes here

    func login(params: [String : String], onSuccess: ((String?) -> Void)?, onError: ((String?) -> Void)?) {
        
        ApiFetcher.fetch(UserApi.login(params: params), success: { (response: ApiResponse<LoginResponse>) -> Void in

            let tokenResult = response.responseData?.token
            onSuccess?(tokenResult)

        }) { (errorMessage, error) in
            onError?(errorMessage)
        }
    }

}
