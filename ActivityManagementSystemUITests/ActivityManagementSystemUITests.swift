//
//  ActivityManagementSystemUITests.swift
//  ActivityManagementSystemUITests
//
//  Created by Jack on 1/5/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import XCTest

class ActivityManagementSystemUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        //app.buttons["登录"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["2017 OOCL年会"].tap()
        app.navigationBars["详情"].buttons["主页"].tap()
        tablesQuery.staticTexts["圣诞礼物交换"].tap()
        app.navigationBars["详情"].buttons["主页"].tap()
        app.tabBars.buttons["我的"].tap()
        tablesQuery.staticTexts["我的收藏"].tap()
        app.navigationBars["我的收藏"].buttons["我的"].tap()
        tablesQuery.staticTexts["退出登录"].tap()
        
    }
    
    func testUI() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["[Voting]:Test11"].tap()
        app.navigationBars["投票"].buttons["主页"].tap()
        tablesQuery.staticTexts["礼物多多，惊喜多多! 大家都交换到自己喜欢的礼物吗？不满意礼物？没关系， 明年还有机会哦！"].tap()
        
    }
    
}
