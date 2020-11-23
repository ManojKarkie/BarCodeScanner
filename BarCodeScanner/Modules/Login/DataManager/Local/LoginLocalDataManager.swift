//
//  LoginLocalDataManager.swift
//  IME Motors
//
//  Created Manoj Karki on 5/19/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//
//

import UIKit

class LoginLocalDataManager: LoginLocalDataManagerInputProtocol {

    init() {}
    
    // Data fetch service methods goes here

     var realmDataManager = RealmDataManager()
     var keychainService =  KeychainService()

    func managerUserProfile(profile: UserProfile) {
        
        try? realmDataManager.deleteAll(UserProfile.self)
        try? realmDataManager.save(object: profile)

    }

    func saveToken(tokenString: String) {
        keychainService.updateAccToken(newToken: tokenString)
    }

    func saveNavDetails(details: NavCustomerDetail) {
        try? realmDataManager.deleteAll(NavCustomerDetail.self)
        try? realmDataManager.save(object: details)
    }

}