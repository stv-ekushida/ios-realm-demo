//
//  RealmDaoHelper.swift
//  ios-realm-demo
//
//  Created by Kushida　Eiji on 2017/03/11.
//  Copyright © 2017年 Kushida　Eiji. All rights reserved.
//

import RealmSwift

final class RealmDaoHelper <T : RealmSwift.Object> {
    let realm: Realm
    
    init() {
        try! realm = Realm()
        defer {
            realm.invalidate()
        }
    }
    
    /**
     * 新規主キー発行
     */
    func newId() -> Int? {
        guard let key = T.primaryKey() else {
            //primaryKey未設定
            return nil
        }
        
        let realm = try! Realm()
        return (realm.objects(T.self).max(ofProperty: key) as Int? ?? 0) + 1
    }
    
    /**
     * 全件取得
     */
    func findAll() -> Results<T> {
        return realm.objects(T.self)
    }
    
    /**
     * 1件目のみ取得
     */
    func findFirst() -> T? {
        return findAll().first
    }
    
    /**
     * 指定キーのレコードを取得
     */
    func findFirst(key: AnyObject) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: key)
    }
    
    /**
     * 最後のレコードを取得
     */
    func findLast() -> T? {
        return findAll().last
    }
    
    /**
     * レコード追加
     */
    func add(object :T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// 複数件のレコードを追加
    ///
    /// - Parameter objects: 複数件のレコード
    func add(objects: [T]) {
        do {
            try realm.write {
                realm.add(objects)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /**
     * T: RealmSwift.Object で primaryKey()が実装されている時のみ有効
     */
    @discardableResult
    func update(object: T, block:(() -> Void)? = nil) -> Bool {
        do {
            try realm.write {
                block?()
                realm.add(object, update: true)
            }
            return true
        } catch let error {
            print(error.localizedDescription)
        }
        return false
    }
    
    @discardableResult
    func update(objects: [T], block:(() -> Void)? = nil) -> Bool {
        do {
            try realm.write {
                block?()
                realm.add(objects, update: true)
            }
            return true
        } catch let error {
            print(error.localizedDescription)
        }
        return false
    }
    
    /**
     * レコード削除
     */
    func delete(object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /**
     * レコード全削除
     */
    func deleteAll() {
        let objs = realm.objects(T.self)
        do {
            try realm.write {
                realm.delete(objs)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
