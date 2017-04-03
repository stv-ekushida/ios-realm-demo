# ios-realm-demo
iOS Realmを利用したCRUD操作のサンプルです。

## 1. PodFile

```
  pod 'RealmSwift' , '<= 2.4.1'
```

## 2. import する

```
import RealmSwift
```

## 3. モデル(Entity)の作成

```
import Foundation
import RealmSwift

class ToDoModel: Object {
    dynamic var taskID = 0
    dynamic var title = ""
    dynamic var limitDate: Date?
    dynamic var isDone = false
    
    override static func primaryKey() -> String? {
        return "taskID"
    }
}
```

## 4. DAOの作成

```:swift
import Foundation
import RealmSwift

final class ToDoDao {
    
    static let dao = RealmDaoHelper<ToDoModel>()
    
    static func add(model: ToDoModel) {
        
        let object = ToDoModel()
        object.taskID = ToDoDao.dao.newId()!
        object.title = model.title
        object.isDone = model.isDone
        object.limitDate = model.limitDate
        ToDoDao.dao.add(d: object)
    }
    
    static func update(model: ToDoModel) {
        
        guard let object = dao.findFirst(key: model.taskID as AnyObject) else {
            return
        }
        object.title = model.title
        object.limitDate = model.limitDate
        object.isDone = model.isDone
        _ = dao.update(d: object)
    }
    
    static func delete(taskID: Int) {
        
        guard let object = dao.findFirst(key: taskID as AnyObject) else {
            return
        }
        dao.delete(d: object)
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
        let objects =  ToDoDao.dao.findAll()
        return objects.map { ToDoModel(value: $0) }
    }
}
```

## 参考

```
import RealmSwift

final class RealmDaoHelper <T : RealmSwift.Object> {
    let realm: Realm
    
    init() {
        try! realm = Realm()
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
     * レコード追加を取得
     */
    func add(d :T) {
        do {
            try realm.write {
                realm.add(d)
            }
        } catch let error as NSError {
            print(error.description)
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
        } catch let error as NSError {
            print(error.description)
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
        } catch let error as NSError {
            print(error.description)
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
        } catch let error as NSError {
            print(error.description)
        }
    }
    
}
```
