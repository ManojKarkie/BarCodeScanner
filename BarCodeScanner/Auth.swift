//
//  Auth.swift
//  IME Motors
//
//  Created by Manoj Karki on 4/28/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//

import Foundation
import Moya

protocol ApiResult {
    var data : Data? {get}
    var error: Error? {get}
}

struct ApiResultModel : ApiResult {
    var data : Data?
    var error: Error?
}

class Auth<T>: MoyaProvider<T> where T: TargetType {

   private static var provider: MoyaProvider<T> {
    
    let endpointClosure = { (target: T) -> Endpoint in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            let token = KeychainService().accToken ?? ""
            print("Bearer \(token)")
            return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": "Bearer \(token)"])
        }
        return MoyaProvider<T>(endpointClosure: endpointClosure)
    }

    class func shared() -> MoyaProvider<T> {
       return provider
    }
}
