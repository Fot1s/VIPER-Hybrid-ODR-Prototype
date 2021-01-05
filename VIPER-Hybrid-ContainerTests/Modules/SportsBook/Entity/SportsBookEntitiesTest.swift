//
//  SportsBookTests.swift
//  VIPER-Hybrid-ContainerTests
//
//  Created by Fotis Chatzinikos on 25/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import XCTest

@testable import VIPER_Hybrid_Container

class SportsBookEntitiesTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    //MARC Entities
    func testEntities() {

        let matchUpdate = MatchUpdate(id: 1, updateFor: .draw, value: 200)

        XCTAssertNotNil(matchUpdate, "matchUpdate should not be nil")
        XCTAssertTrue(matchUpdate.id == 1)
        XCTAssertTrue(matchUpdate.updateFor == .draw)
        XCTAssertTrue(matchUpdate.value == 200)

    }

}
