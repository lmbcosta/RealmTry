//
//  UserRealm.swift
//  RealmTry
//
//  Created by Luis  Costa on 24/03/18.
//  Copyright © 2018 Luis  Costa. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var name: String? = nil
    var age = RealmOptional<Int>()
    
}
