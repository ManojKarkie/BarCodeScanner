//
//  ApiFetcher.swift
//  IME Motors
//
//  Created by Manoj Karki on 4/28/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import SwiftyJSON
import Alamofire

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

typealias apiCallSuccess<R: Mappable> =  ((R?) -> Void)?
typealias apiCallFailure = ((String?, Error?) -> Void)?

enum APIErrorMessage {
    static let somethingWentWrong = "Something went wrong, please try later."
}

struct ApiStatusCode {
    
    static let successCode: Int = 100
    static let failtureCode: Int = 101
}

struct ApiFetcher {
    
    static func fetch<T, A: TargetType>(_ target : A, success: @escaping (_ response: T) -> Void, failure: @escaping (_ errorMessage: String?, _ error: Error?) -> Void) where T: Mappable {
        
        Auth.shared().request(target) { (response) in
            switch response {
            case let .success(value):
                
                let json = JSON(value.data)
                
                print("Fetcher response, \(target.path) \(json)")
                
                if json.dictionaryObject == nil {
                    failure("Something Went Wrong, Please try later.", nil)
                    return
                }
                
                guard let result = Mapper<T>().map(JSON: json.dictionaryObject ?? [:]) else {
                    failure("Something Went Wrong, Please try later.", nil)
                    return
                }
                
                if let responseCode = json["responseCode"].int {
                    if responseCode == ApiStatusCode.successCode
                    {
                        success(result)
                    }else {
                        failure(json["responseDescription"].stringValue, nil)
                    }
                }else if let responseCode = json["responseCode"].string {
                    if responseCode == "\(ApiStatusCode.successCode)"
                    {
                        success(result)
                    }else {
                        failure(json["responseDescription"].stringValue, nil)
                    }
                }
                
            case let .failure(error):
                failure(error.localizedDescription, error)
                break
            }
        }
    }

    static func downloadFile(fileUrl: URL, onSuccess: @escaping (_ data: Data) -> Void, onError: @escaping (_ errorMessage: String?) -> Void ) {
        
        Alamofire.request(fileUrl).responseData { (response) in
          switch response.result {
            case let .success(data):
                onSuccess(data)
            case let .failure(error):
                onError(error.localizedDescription)
          }
        }
    }
    
}
