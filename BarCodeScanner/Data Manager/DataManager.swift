//
//  DataManager.swift
//  IME Motors
//
//  Created by Manoj Karki on 4/28/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//

import Foundation
import RealmSwift

//MARK:- Realm Data Manager

public struct Sorted {
    var key: String
    var ascending: Bool = true
}

protocol DataManager {
    
    func save(object: Object) throws
     func saveAndUpdate(object: Object) throws
    func update(object: Object) throws

    func delete(object: Object) throws
    func deleteAll<T: Object>(_ modelType: T.Type) throws
    
    func fetch<T: Object>(_ model: T.Type) -> [T]
    func fetch<T: Object>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, completion: (([T]) -> ()))
}

struct RealmDataManager: DataManager {
    
    func fetch<T>(_ model: T.Type) -> [T] where T : Object {
        
        guard let realm = RealmManager.realm else {
            return []
        }

        let result = realm.objects(model)
        return Array(result)
    }
    
    func fetch<T>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, completion: (([T]) -> ())) where T : Object {
        
        guard let realm = RealmManager.realm else {
            return
        }
        
        let result = realm.objects(model).filter(predicate!)
        completion(Array(result))
        
    }
    
    func save(object: Object) throws {
        
        let realmInstance = RealmManager.realm
        
        do {
            try realmInstance?.write {
                realmInstance?.add(object)
            }
        } catch {
            print("error saving realm object \(error.localizedDescription)")
            throw error
        }

    }
    
    func saveObjects(objects: [Object]) throws {
           
        guard let realm = RealmManager.realm else {  return }
        
        try realm.write {

            for object in objects {
                realm.add(object)
            }
        }

    }

    func update(object: Object) {
        
//       guard let realm = RealmManager.realm else {  return }
//       
//       try realm.write {
//        realm.add()
//        
//       }

    }

    func saveAndUpdate(object: Object) throws {
           
           let realmInstance = RealmManager.realm
           
           do {
               try realmInstance?.write {
                   realmInstance?.add(object)
               }
           } catch {
               print("error saving realm object \(error.localizedDescription)")
               throw error
           }

       }
    
    func delete(object: Object) throws {
        
    }
    
    func deleteAll<T>(_ modelType: T.Type) throws where T : Object {

        guard let realm = RealmManager.realm else {
            return
        }
        
        try realm.write {

            let objects = realm.objects(modelType)
            for object in objects {
                realm.delete(object)
            }
        }
        
    }

}

