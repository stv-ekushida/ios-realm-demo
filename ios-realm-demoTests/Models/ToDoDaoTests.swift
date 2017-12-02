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
        ToDoDao.add(model:object)
        
        //Verify
        verifyItem(taskID: 1, title: "タイトル", isDone: true, limiteDateStr: "2016/01/01")
    }
    
    func testUpdateItem() {
        
        //Setup
        let object = ToDoModel()
        object.taskID = 1
        object.title = "タイトル"
        object.isDone = true
        object.limitDate = "2016/01/01".str2Date(dateFormat: "yyyy/MM/dd")
        ToDoDao.add(model:object)

        //Exercise
        if let object = ToDoDao.findByID(taskID: 1) {
            
            let updateObject = ToDoModel(value: object)
            updateObject.title = "タイトル更新"
            updateObject.isDone = false
            ToDoDao.update(model: updateObject)
            
            //Verify
            verifyItem(taskID: 1, title: "タイトル更新", isDone: false, limiteDateStr: "2016/01/01")
        }
    }
    
    func testDeleteItem() {
        
        //Setup
        let object = ToDoModel()
        object.taskID = 1
        object.title = "タイトル"
        object.isDone = true
        object.limitDate = "2016/01/01".str2Date(dateFormat: "yyyy/MM/dd")
        
        //Exercise
        ToDoDao.add(model:object)
        ToDoDao.delete(taskID: 1)
        
        //Verify
        verifyCount(count:0)
    }
    
    func testFindAllItem() {
        
        //Setup
        let tasks = [ToDoModel(),ToDoModel(),ToDoModel()]
        
        //Exercise
        _ = tasks.map {
            ToDoDao.add(model:$0)
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
        ToDoDao.add(model:object)
        let result = ToDoDao.findByID(taskID: 1)
        
        //Verify
        XCTAssertEqual(result?.taskID, 1)
    }
    
    //MARK:-private method
    private func verifyItem(taskID: Int, title: String, isDone: Bool, limiteDateStr: String) {
        
        let result = ToDoDao.findAll()
        
        XCTAssertEqual(result.first?.taskID, taskID)
        
        if let title = result.first?.title {
            XCTAssertEqual(title, title)
        }
        
        if let isDone = result.first?.isDone {
            
            if isDone {
                XCTAssertTrue(isDone)
            }
            else {
                XCTAssertFalse(isDone)
            }
        }
        
        if let limiteDate = result.first?.limitDate?.date2Str(dateFormat: "yyyy/MM/dd") {
            XCTAssertEqual(limiteDate, limiteDateStr)
        }
    }
    
    private func verifyCount(count: Int) {
        
        let result = ToDoDao.findAll()
        XCTAssertEqual(result.count, count)
    }
}
