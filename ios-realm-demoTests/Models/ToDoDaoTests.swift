//
//  ToDoDaoTests.swift
//  ios-realm-demo
//
//  Created by Kushida　Eiji on 2017/02/18.
//  Copyright © 2017年 Kushida　Eiji. All rights reserved.
//

import XCTest
@testable import ios_realm_demo

class ToDoDaoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        ToDoDao.deleteAll()
    }
    
    func testAddItem() {
        
        //Setup
        let object = ToDoModel()
        object.taskID = 1
        object.title = "タイトル"
        object.isDone = true
        object.limitDate = "2016/01/01".str2Date(dateFormat: "yyyy/MM/dd")
        
        //Exercise
        ToDoDao.add(object:object)
        
        //Verify
        verifyItem(taskID: 1, title: "タイトル", isDone: true, limiteDateStr: "2016/01/01")
    }
    
    func testAddItems() {
        var objects = [ToDoModel]()
        
        //Setup
        for i in 0...5 {
            let object = ToDoModel()
            object.taskID = i + 1
            object.title = "タイトル\(i)"
            object.isDone = i % 2 == 0
            object.limitDate = "2016/01/01".str2Date(dateFormat: "yyyy/MM/dd")            
            objects.append(object)
        }
        //Exercise
        ToDoDao.add(objects: objects)
        
        //Verify
        verifyItem(taskID: 1, title: "タイトル0", isDone: true, limiteDateStr: "2016/01/01")
        verifyItem(taskID: 2, title: "タイトル1", isDone: false, limiteDateStr: "2016/01/01")
        verifyItem(taskID: 3, title: "タイトル2", isDone: true, limiteDateStr: "2016/01/01")
        verifyItem(taskID: 4, title: "タイトル3", isDone: false, limiteDateStr: "2016/01/01")
        verifyItem(taskID: 5, title: "タイトル4", isDone: true, limiteDateStr: "2016/01/01")
    }
    
    func testUpdateItem() {
        
        //Setup
        let object = ToDoModel()
        object.taskID = 1
        object.title = "タイトル"
        object.isDone = true
        object.limitDate = "2016/01/01".str2Date(dateFormat: "yyyy/MM/dd")
        ToDoDao.add(object:object)

        //Exercise
        if let object = ToDoDao.findByID(taskID: 1) {
            
            let updateObject = ToDoModel(value: object)
            updateObject.title = "タイトル更新"
            updateObject.isDone = false
            ToDoDao.update(object: updateObject)
            
            //Verify
            verifyItem(taskID: 1, title: "タイトル更新", isDone: false, limiteDateStr: "2016/01/01")
        }
    }
    
    func testUpdateItems() {
        
        var objects = [ToDoModel]()
        var updateDbjects = [ToDoModel]()

        //Setup
        for i in 0...5 {
            let object = ToDoModel()
            object.taskID = i + 1
            object.title = "タイトル\(i)"
            object.isDone = i % 2 == 0
            object.limitDate = "2016/01/01".str2Date(dateFormat: "yyyy/MM/dd")
            objects.append(object)
        }
        ToDoDao.add(objects: objects)

        //Exercise
        let results = ToDoDao.findAll()
        for (i, object) in results.enumerated() {
            object.title = "更新タイトル\(i)"
            object.isDone = i % 2 != 0
            object.limitDate = "2017/01/01".str2Date(dateFormat: "yyyy/MM/dd")
            updateDbjects.append(object)
        }
        ToDoDao.update(objects: updateDbjects)
        
        //Verify
        verifyItem(taskID: 1, title: "更新タイトル0", isDone: false, limiteDateStr: "2017/01/01")
        verifyItem(taskID: 2, title: "更新タイトル1", isDone: true, limiteDateStr: "2017/01/01")
        verifyItem(taskID: 3, title: "更新タイトル2", isDone: false, limiteDateStr: "2017/01/01")
        verifyItem(taskID: 4, title: "更新タイトル3", isDone: true, limiteDateStr: "2017/01/01")
        verifyItem(taskID: 5, title: "更新タイトル4", isDone: false, limiteDateStr: "2017/01/01")
    }
    
    func testDeleteItem() {
        
        //Setup
        let object = ToDoModel()
        object.taskID = 1
        object.title = "タイトル"
        object.isDone = true
        object.limitDate = "2016/01/01".str2Date(dateFormat: "yyyy/MM/dd")
        
        //Exercise
        ToDoDao.add(object:object)
        ToDoDao.delete(taskID: 1)
        
        //Verify
        verifyCount(count:0)
    }
    
    func testFindAllItem() {
        
        //Setup
        let tasks = [ToDoModel(),ToDoModel(),ToDoModel()]
        
        //Exercise
        _ = tasks.map {
            ToDoDao.add(object:$0)
        }
        
        //Verify
        verifyCount(count:3)
    }
    
    func testFindItem() {
        
        //Setup
        let object = ToDoModel()
        object.taskID = 1
        object.title = "タイトル"
        object.isDone = true
        object.limitDate = "2016/01/01".str2Date(dateFormat: "yyyy/MM/dd")
        
        //Exercise
        ToDoDao.add(object:object)
        let result = ToDoDao.findByID(taskID: 1)
        
        //Verify
        XCTAssertEqual(result?.taskID, 1)
    }
    
    //MARK:-private method
    private func verifyItem(taskID: Int, title: String, isDone: Bool, limiteDateStr: String) {
        
        let result = ToDoDao.findByID(taskID: taskID)
        
        XCTAssertEqual(result?.taskID, taskID)
        
        if let title = result?.title {
            XCTAssertEqual(title, title)
        }
        
        if let isDone = result?.isDone {
            
            if isDone {
                XCTAssertTrue(isDone)
            }
            else {
                XCTAssertFalse(isDone)
            }
        }
        
        if let limiteDate = result?.limitDate?.date2Str(dateFormat: "yyyy/MM/dd") {
            XCTAssertEqual(limiteDate, limiteDateStr)
        }
    }
    
    private func verifyCount(count: Int) {
        
        let result = ToDoDao.findAll()
        XCTAssertEqual(result.count, count)
    }
}
