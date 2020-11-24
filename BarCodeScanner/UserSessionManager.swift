//
//  UserSessionManager.swift
//
//  Created by Manoj Karki on 5/20/20.
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
