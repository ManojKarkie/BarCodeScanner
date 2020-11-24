//
//  UserSessionManager.swift
//
//  Created by Manoj Karki on 5/20/20.
//

import Foundation

struct UserSessionManager {

    static var isUserLoggedIn: Bool {
        let userDefaults = UserDefaults.standard
        let token = userDefaults.value(forKey: "BSC_ACCESS_TOKEN") as? String
        return token != nil && !(token ?? "").isEmpty
    }

    static func logout() {
        let keychainService = KeychainService()
        keychainService.clearAccToken()
        
        let realmDataManager = RealmDataManager()
        try? realmDataManager.deleteAll(UserProfile.self)
    }

}
