//
//  ToDoModelTests.swift
//  ios-realm-demo
//
//  Created by Kushida　Eiji on 2017/02/17.
//  Copyright © 2017年 Kushida　Eiji. All rights reserved.
//

import XCTest
@testable import ios_realm_demo

class ToDoModelTests: XCTestCase {
    
    let item = ToDoModel()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testToDoModelDefault() {
        
        XCTAssertEqual(item.taskID, 0)
        XCTAssertEqual(item.title, "")
        XCTAssertNil(item.limitDate)
        XCTAssertFalse(item.isDone)
    }
    
    func testToDoModel() {

        item.taskID = 1
        item.title = "タイトル"
        item.isDone = true
        item.limitDate = "2016/01/01".str2Date(dateFormat: "yyyy/MM/dd")
        
        XCTAssertEqual(item.taskID, 1)
        XCTAssertEqual(item.title, "タイトル")
        XCTAssertTrue(item.isDone)
        XCTAssertEqual(item.limitDate?.date2Str(dateFormat: "yyyy/MM/dd"), "2016/01/01")
    }
}
