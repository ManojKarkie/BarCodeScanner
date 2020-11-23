//
//  KeychainService.swift
//  IMEPayWallet
//
//  Created by Manoj's iMac on 9/1/17.
//  Copyright © 2017 imedigital. All rights reserved.
//

import Foundation
import Valet

final class KeychainService {

    static let identifier =  "IME_MOTORS_KEYCHAIN"
    static let accessTokenKey = "IME_MOTORS_ACCESS_TOKEN"

    private lazy var imValet: Valet? = {
        guard let valetId = Identifier.init(nonEmpty: KeychainService.identifier) else {
            return nil
        }
        return Valet.valet(with: valetId, accessibility: .whenUnlocked)
    }()

    var accToken: String? {
      return imValet?.string(forKey: KeychainService.accessTokenKey)
    }

    func updateAccToken(newToken: String) {
        imValet?.set(string: newToken, forKey: KeychainService.accessTokenKey)
    }

    func clearAccToken() {
        imValet?.removeObject(forKey: KeychainService.accessTokenKey)
    }
}
