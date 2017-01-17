//
//  ActivityManagementSystemTests.swift
//  ActivityManagementSystemTests
//
//  Created by Jack on 1/5/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import XCTest
@testable import ActivityManagementSystem

class ActivityManagementSystemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testPerformanceRequestData() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            let request = RequestData()
            request.request()
        }
    }
    
}
