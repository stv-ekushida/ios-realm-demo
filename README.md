# ios-realm-demo
iOS Realmを利用したCRUD操作のサンプルです。

## 1. Cartfile

```
  github "realm/realm-cocoa" "v3.0.2"
```

## 2. import する

```
import RealmSwift
```

## 3. モデル(Entity)の作成

```swift:ToDoModel.swift
import Foundation
import RealmSwift

class ToDoModel: Object {
    @objc dynamic var taskID = 0
    @objc dynamic var title = ""
    @objc dynamic var limitDate: Date?
    @objc dynamic var isDone = false
    
    override static func primaryKey() -> String? {
        return "taskID"
    }
}
```

## 4. DAOの作成

```swift:ToDoDao.swift
import Foundation
import RealmSwift

final class ToDoDao {
    
    static let dao = RealmDaoHelper<ToDoModel>()
    
    static func add(object: ToDoModel) {
        object.taskID = ToDoDao.dao.newId()!
        ToDoDao.dao.add(object: object)
    }
    
    static func add(objects: [ToDoModel]) {
        let newId = ToDoDao.dao.newId()!
        for (i, object) in objects.enumerated() {
           object.taskID = Int(i + newId)
        }
        dao.add(objects: objects)
    }

    static func update(object: ToDoModel) {
        dao.update(object: object)
    }

    static func update(objects: [ToDoModel]) {
        dao.update(objects: objects)
    }

    static func delete(taskID: Int) {
        
        guard let object = dao.findFirst(key: taskID as AnyObject) else {
            return
        }
        dao.delete(object: object)
    }
    
    static func deleteAll() {        
        dao.deleteAll()
    }
    
    static func findByID(taskID: Int) -> ToDoModel? {
        guard let object = dao.findFirst(key: taskID as AnyObject) else {
            return nil
        }
        return object
    }
    
    static func findAll() -> [ToDoModel] {
        return ToDoDao.dao.findAll().map { ToDoModel(value: $0) }
    }
}
```

## 参考

```swift:RealmDaoHelper.swift
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
    func update(d: T, block:(() -> Void)? = nil) -> Bool {
        do {
            try realm.write {
                block?()
                realm.add(d, update: true)
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
    func delete(d: T) {
        do {
            try realm.write {
                realm.delete(d)
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
```
