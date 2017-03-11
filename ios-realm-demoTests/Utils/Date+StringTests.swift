//
//  Date+StringTests.swift
//  ios-realm-demo
//
//  Created by Kushida　Eiji on 2017/02/18.
//  Copyright © 2017年 Kushida　Eiji. All rights reserved.
//

import XCTest
@testable import ios_realm_demo

class Date_StringTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDate2Str() {
        
        let date = "2016/01/01".str2Date(dateFormat: "yyyy/MM/dd")
        XCTAssertEqual(date.date2Str(dateFormat: "yyyy/MM/dd"), "2016/01/01")
    }
    
    func testDate2StrFormatHyphen() {
        
        let date = "2016-01-01".str2Date(dateFormat: "yyyy-MM-dd")
        XCTAssertEqual(date.date2Str(dateFormat: "yyyy-MM-dd"), "2016-01-01")
    }

}
