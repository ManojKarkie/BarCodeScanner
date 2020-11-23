//
//  UserSessionManager.swift
//  IME Motors
//
//  Created by Manoj Karki on 5/20/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//

import Foundation

struct UserSessionManager {

    static var isUserLoggedIn: Bool {
        let keychainService = KeychainService()
        let token = keychainService.accToken
        return token != nil && !(token ?? "").isEmpty
    }
    
    static func logout() {
        let keychainService = KeychainService()
        keychainService.clearAccToken()
        
        let realmDataManager = RealmDataManager()
        try? realmDataManager.deleteAll(UserProfile.self)
    }

}
