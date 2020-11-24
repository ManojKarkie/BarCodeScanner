//
//  UserApi.swift
//
//  Created by Manoj Karki on 5/21/20.
//

import Foundation
import Moya

enum UserApi {

    
    case login(params: [String: String])

}

extension UserApi: TargetType {

    var sampleData: Data {
        return "".data(using: .utf8)!
    }

    var headers: [String: String]? {
        return nil
    }

    var baseURL: URL {
        return ServerUrl.baseUrl
    }

    var path: String {
        switch self {
       
        case .login:
            return "Customer/authenticate"
    
        }
    }

    var method: Moya.Method {

        switch self {
       
        case .login:
            return .post

        }
    }

    var parameters: [String: Any]? {

        switch self {
       
        case let .login(params):
            return params
        
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }

    var task: Task {
        
        switch self {
        
        case  let .login(params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        }
    }
    
    var validate: Bool {
        return true
    }
}

