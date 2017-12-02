//
//  ToDoDao.swift
//  ios-realm-demo
//
//  Created by Kushida　Eiji on 2017/02/18.
//  Copyright © 2017年 Kushida　Eiji. All rights reserved.
//

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
