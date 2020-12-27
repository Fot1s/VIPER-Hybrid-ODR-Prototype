//
//  SportsBookRouterTest.swift
//  VIPER-Hybrid-ContainerTests
//
//  Created by Demitri Delinikolas on 27/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import XCTest

@testable import VIPER_Hybrid_Container

class SportsBookRouterTest: XCTestCase {
    
    //The viewcontroller returned from the static assembleModule
    var sut: UIViewController?
    
    override func setUp() {
        super.setUp()
        
        sut = SportsBookRouter.assembleModule()
        
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testRouterInitializesCorrectControllerAndViperConnections() {
        //controller is a SportsBookViewController and a SportsBookView
        XCTAssertTrue(sut is SportsBookViewController)
        XCTAssertTrue(sut is SportsBookView)

        let sutAsSportsBook = sut as! SportsBookView
        
        //SportsBookView has a presenter
        XCTAssertNotNil(sutAsSportsBook.presenter)
        
        //presenter has interactor router and weak view
        XCTAssertNotNil(sutAsSportsBook.presenter.interactor)
        XCTAssertNotNil(sutAsSportsBook.presenter.router)
        XCTAssertNotNil(sutAsSportsBook.presenter.view)
        
        //the view is the original SportsBookView
        XCTAssertTrue(sutAsSportsBook === sutAsSportsBook.presenter.view)

        //interactor has output and is set to the presenter
        XCTAssertNotNil(sutAsSportsBook.presenter.interactor.output)
        XCTAssertTrue(sutAsSportsBook.presenter! === sutAsSportsBook.presenter.interactor.output as! SportsBookPresentation)

        //router has viewController and the controller is the sut:
        XCTAssertNotNil(sutAsSportsBook.presenter.router.viewController)
        XCTAssertTrue(sutAsSportsBook.presenter.router.viewController === sut)

        //If sut was set to SportsBookRouter() we could call its static assemble like this:
        //let viewController = type(of: sut!.self).assembleModule()
    }
}

