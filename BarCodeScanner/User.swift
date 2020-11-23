//
//  User.swift
//  IME Motors
//
//  Created by Manoj Karki on 5/21/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapperAdditions

class UserProfile: Object {

    @objc dynamic var name: String?
    @objc dynamic var socialLoginType: String = ""
    @objc dynamic var address: String?
    @objc dynamic var contactNumber: String?
    @objc dynamic var email: String?
    @objc dynamic var discountGroup: String?
    @objc dynamic var profilePhotoUrl: String?

    required init() {
        super.init()
    }

    convenience init(profileData: ProfileData) {
        self.init()
        self.name = profileData.fullName
        self.address = profileData.address
        self.contactNumber = profileData.mobile
        self.email = profileData.email
        self.discountGroup = profileData.discountGroup
    }

    class var current: UserProfile? {
        let realmManager = RealmDataManager()
        return realmManager.fetch(UserProfile.self).last
    }

}


class ProfileData: Mappable {
 
    var userName: String?
    var fullName: String?
    var address: String?
    var mobile: String?
    var email: String?
    var discountGroup: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    init() {}

    func mapping(map: Map) {
        discountGroup <- map["customerPriceGroup"]
        userName <- map["userName"]
        fullName <- map["fullName"]
        address <- map["address"]
        mobile <- map["mobile"]
        email <- map["email"]
    }
}

class LoginResponse: Mappable {

    var token: String?

    required convenience init?(map: Map) {
        self.init()
    }
    
    init() {}

    func mapping(map: Map) {
        token <- map["token"]
    }
}

class TokenResult: Mappable {

    var result: String?
    var status: Int?

    required convenience init?(map: Map) {
        self.init()
    }
    
    init() {}
    
    func mapping(map: Map) {
        result <- map["result"]
        status <- map["status"]
    }

}

class Token: Mappable {

    var token: String?

    required convenience init?(map: Map) {
        self.init()
    }
    
    init() {}
    
    func mapping(map: Map) {
        token <- map["token"]
    }
    
}

class NavCustomerDetail: Object, Mappable {

    @objc dynamic var navEmail: String?
    @objc dynamic var navMobileNumber: String?
    @objc dynamic var navContactNumber: String?
    @objc dynamic var navFullName: String?
    @objc dynamic var navAddress: String?
    @objc dynamic var navCustomerCode: String?
    @objc dynamic var discountGroup: String?

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        navEmail <- map["email"]
        navMobileNumber <- map["mobileNumber"]
        navContactNumber <- map["customerCode"]
        navAddress <- map["address"]
        navFullName <- map["fullName"]
        navCustomerCode <- map["customerCode"]
        discountGroup <- map["customerDiscGroup"]
    }
}




