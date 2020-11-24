//
//  UserDefaultManager.swift
//
//  Created by Manoj Karki on 4/26/20.
//

import Foundation

struct UserDefaultManager {
    
    static var isOnboardingShown: Bool {
        
        get {
            let userDefaults = UserDefaults.standard
            let isOnboardShown = userDefaults.value(forKey: IS_ONBOARDING_SHOWN) as? Bool
            return isOnboardShown ?? false
        }

    }
    
    static func setOnboardingShown() {
         let userDefaults = UserDefaults.standard
         userDefaults.setValue(true, forKey: IS_ONBOARDING_SHOWN)
    }

}
