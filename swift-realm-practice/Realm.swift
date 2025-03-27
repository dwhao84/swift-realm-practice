//
//  Realm.swift
//  swift-realm-practice
//
//  Created by Dawei Hao on 2025/3/27.
//

import UIKit
import RealmSwift

class Product: Object {
    @Persisted(primaryKey: true) var id = UUID().uuidString
    @Persisted var articleNumber: String = ""
    @Persisted var location: String = ""
    @Persisted var qty: Int = 0
    @Persisted var timestamp: Date = Date()
    
    convenience init(articleNumber: String, location: String, qty: Int) {
        self.init()
        self.articleNumber = articleNumber
        self.location = location
        self.qty = qty
        self.timestamp = Date()
    }
}

