//
//  RealmService.swift
//  RealmTry
//
//  Created by Luis  Costa on 31/03/18.
//  Copyright © 2018 Luis  Costa. All rights reserved.
//

import Foundation
import RealmSwift

typealias Database = ReadableDatabase & WritableDatabase & NotifiableDatabase

protocol ReadableDatabase {
    func loadObjects<T: Object>(_ type: T.Type) -> Results<T>
}

protocol WritableDatabase {
    func create<T: Object>(_ object: T)
    func update<T: Object>(_ object: T, withDictionary dictionary: [String: Any?])
    func delete<T: Object>(_ object: T)
}

protocol NotifiableDatabase {
    func postDatabaseError(_ error: Error)
    func observeDatabaseError(in viewController: UIViewController, completionHandler: @escaping (Error?) -> Void)
    func unobserveDatabaseError(in viewController: UIViewController)
}

class RealmService {
    
    // Singleton instance
    static let shared = RealmService()
    
    fileprivate init() {
        self.realm = try! Realm()
    }
    
    // Local Vars
    fileprivate let realm: Realm!
}

// MARK: - ReadableDatabase
extension RealmService: ReadableDatabase {
    func loadObjects<T>(_ type: T.Type) -> Results<T> where T: Object {
        return realm.objects(type.self)
        
    }
}

// MARK: - WritableDatabase
extension RealmService: WritableDatabase {
    func create<T: Object>(_ object: T) {
        do {
            try realm.write { realm.add(object) }
        }
        catch {
            // Notify observers
            self.postDatabaseError(error)
        }
    }
    
    func update<T: Object>(_ object: T, withDictionary dictionary: [String: Any?]) {
        do {
            try realm.write { dictionary.forEach({ object.setValue($0.value, forKey: $0.key) }) }
        }
        catch {
            self.postDatabaseError(error)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do { try realm.write { realm.delete(object) } }
        catch { self.postDatabaseError(error) }
    }
}

// MARK: - NotifiableDatabase
extension RealmService: NotifiableDatabase {
    // Notifiable Database
    func postDatabaseError(_ error: Error) {
        // Post notification
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    
    func observeDatabaseError(in viewController: UIViewController, completionHandler: @escaping (Error?) -> Void) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"), object: viewController, queue: nil) { notification in
            let error = notification.object as? Error
            completionHandler(error)
        }
    }
    
    func unobserveDatabaseError(in viewController: UIViewController) {
        NotificationCenter.default.removeObserver(viewController, name: NSNotification.Name("RealmError"), object: nil)
    }
    
    func observeDatabaseChanges(with completionHandler: (() -> Void)? = nil) -> NotificationToken {
         return self.realm.observe { (_, _) in
            if let completion = completionHandler { completion() }
        }
    }
    
    func unobserveDatabaseChanges(to token: NotificationToken) {
        // Stop notifications for subscriber that sent this token
        token.invalidate()
    }
}

