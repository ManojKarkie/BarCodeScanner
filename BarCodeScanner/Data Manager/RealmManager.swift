//
//  RealmManager.swift
//
//  Created by Manoj Karki on 4/28/20.
//

import Foundation
import RealmSwift

//MARK:- Realm Provider/Manager

struct RealmManager {

    private static var currentConfig = Realm.Configuration(schemaVersion:1)

    func configure() {
           let config = Realm.Configuration (
               schemaVersion: 1,
               migrationBlock: { migration, oldSchemaVersion in
                   
                   // We haven’t migrated anything yet, so oldSchemaVersion == 0
                   if (oldSchemaVersion < 1) {
                       // Nothing to do!
                       // Realm will automatically detect new properties and removed properties
                       // And will update the schema on disk automatically
                   }
           })
           RealmManager.currentConfig = config
           Realm.Configuration.defaultConfiguration = config
    }

    static var realm: Realm? {
        do {
            return try Realm(configuration: currentConfig)
        } catch _ {
            return nil
        }
    }

}

