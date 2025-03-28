//
//  Realm.swift
//  swift-realm-practice
//
//  Created by Dawei Hao on 2025/3/27.
//

import UIKit
import RealmSwift

// MARK: - 定義Product 為 RealmSwiftObject Obeject的類別。
class Product: Object {
    // MARK: -  將 @Persisted 定義為持久變數的屬性
    @Persisted(primaryKey: true) var id = UUID().uuidString
    @Persisted var articleNumber: String = ""
    @Persisted var location: String = ""
    @Persisted var qty: Int = 0
    @Persisted var timestamp: Date = Date()
    
    // MARK: - init初始化這些內容，目前設定為 貨號、地點、數量、時間。
    convenience init(articleNumber: String, location: String, qty: Int) {
        self.init()
        self.articleNumber = articleNumber
        self.location = location
        self.qty = qty
        self.timestamp = Date()
    }
}

