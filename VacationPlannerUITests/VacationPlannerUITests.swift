//
//  VacationPlannerUITests.swift
//  VacationPlannerUITests
//
//  Created by John Kennedy Martins Alves on 07/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import XCTest

class VacationPlannerUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testInitialContentState() {
        let app = XCUIApplication()
        let button = app.buttons["SearchButton"]
        
        XCTAssert(!button.isEnabled)
    }

}
