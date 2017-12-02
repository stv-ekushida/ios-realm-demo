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
    
    static func add(model: ToDoModel) {
        model.taskID = ToDoDao.dao.newId()!
        ToDoDao.dao.add(object: model)
    }
    
    static func update(model: ToDoModel) {
        _ = dao.update(d: model)
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
