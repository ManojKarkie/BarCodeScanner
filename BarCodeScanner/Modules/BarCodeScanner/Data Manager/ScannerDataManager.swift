//
//  ScannerDataManager.swift
//  BarCodeScanner
//
//  Created by Manoj Karki on 11/24/20.
//

import Foundation

protocol ScannerAPIDataManagerInputProtocol {
    
    
}

class ScannerDataManager {

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
