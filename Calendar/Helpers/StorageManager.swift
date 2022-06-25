//
//  StorageManager.swift
//  Calendar
//
//  Created by Денис on 27.03.2022.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ event: Event) {
        try! realm.write {
            realm.add(event)
        }
    }

    static func deleteObject(_ event: Event) {
        try! realm.write {
            realm.delete(event)
        }
    }
    
    static func saveOptions(_ options: Options) {
        try! realm.write {
            realm.add(options)
        }
    }
    
    static func deleteOptions(_ options: Options) {
        try! realm.write {
            realm.delete(options)
        }
    }
    
}
