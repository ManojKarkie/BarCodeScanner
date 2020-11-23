//
//  ResponseModel.swift
//  IME Motors
//
//  Created by Manoj Karki on 4/28/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//

import Foundation
import ObjectMapper

//MARK:- Generic Response Models

class BaseResponse: Mappable {

    var responseCode: Int?
    var responseDescription: String?
    var responseData: String?

    required convenience init?(map: Map) {
        self.init()
    }

    init() {}

    func mapping(map: Map) {
        responseCode <- map["responseCode"]
        responseDescription <- map["responseDescription"]
        responseData <- map["responseData"]
    }

}


class ApiResponse<T: Mappable>: Mappable {

    var responseCode: String?
    var responseDescription: String?
    var responseData: T?

    required convenience init?(map: Map) {
        self.init()
    }

    init() {}

    func mapping(map: Map) {
        responseCode <- map["responseCode"]
        responseDescription <- map["responseDescription"]
        responseData <- map["responseData"]
    }

}

class ApiResponseArray<T: Mappable>: Mappable {

    var responseCode: Int?
    var responseDescription: String?
    var responseData: [T] = [T]()

    required convenience init?(map: Map) {
        self.init()
    }
    
    init() {}

    func mapping(map: Map) {
        responseCode <- map["responseCode"]
        responseDescription <- map["responseDescription"]
        responseData <- map["responseData"]
    }

}


