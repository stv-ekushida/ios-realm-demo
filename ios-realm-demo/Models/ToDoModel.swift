//
//  ToDoModel.swift
//  ios-realm-demo
//
//  Created by Kushida　Eiji on 2017/02/17.
//  Copyright © 2017年 Kushida　Eiji. All rights reserved.
//

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
