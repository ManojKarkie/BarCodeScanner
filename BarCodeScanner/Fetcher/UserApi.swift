//
//  UserApi.swift
//  IME Motors
//
//  Created by Manoj Karki on 5/21/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//

import Foundation
import Moya

enum UserApi {

    case register(params: [String: String])
    case authExternalLogin(params: [String: String])
    case login(params: [String: String])
    case customerCodeLogin(params: [String: String])
    case verifyCustomerCode(params: [String: String])
    case getProfile
    case forgotPassword(params: [String: String])
    case getVehicleProfile(customerCode: String)
    case changePassword(params: [String: String])
    case editProfile(params: [String: String])
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
        case .register:
            return "Customer/register"
        case .authExternalLogin:
            return "Customer/externalLogin"
        case .login:
            return "Customer/authenticate"
        case .customerCodeLogin:
            return "Customer/IMEMotorCustomerLogin"
        case .verifyCustomerCode:
            return "Customer/VerifyCustomerCode"
        case .getProfile:
            return "Customer/profile"
        case .forgotPassword:
            return "Customer/forgetpassword"
        case let .getVehicleProfile(code):
            return "Customer/CustomerVehicles/" + code
        case .changePassword:
            return "Customer/changepassword"
        case .editProfile:
            return "Customer/profile/edit"
        }
    }

    var method: Moya.Method {

        switch self {
        case .authExternalLogin:
            return .post
        case .login,.forgotPassword, .register, .changePassword, .editProfile:
            return .post
        case .customerCodeLogin:
            return .post
        case .verifyCustomerCode:
            return .post
        case .getProfile, .getVehicleProfile:
            return .get
        }
    }

    var parameters: [String: Any]? {

        switch self {
        case let .register(params), let  .authExternalLogin(params):
            return params
        case let .login(params), let .forgotPassword(params):
            return params
        case let .customerCodeLogin(params):
            return params
        case let .verifyCustomerCode(params):
            return params
        case let .changePassword(params), let .editProfile(params):
            return params
        default:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }

    var task: Task {
        
        switch self {
        case let  .authExternalLogin(params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case  let .login(params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case  let .customerCodeLogin(params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .verifyCustomerCode(params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .forgotPassword(params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .register(params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .changePassword(params), let .editProfile(params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var validate: Bool {
        return true
    }
}

