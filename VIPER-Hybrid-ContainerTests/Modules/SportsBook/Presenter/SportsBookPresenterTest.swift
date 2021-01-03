//
//  SportsBookRouterTest.swift
//  VIPER-Hybrid-ContainerTests
//
//  Created by Fotis Chatzinikos on 27/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import XCTest

@testable import VIPER_Hybrid_Container

class SportsBookPresenterTest: XCTestCase {
    
    var sut: SportsBookPresenter?
    
    var mockView: MockSportsBookView?
    var mockInteractor: MockSportsBookInteractor?
    var mockRouter: MockSportsBookRouter?
    
    override func setUp() {
        super.setUp()
        
        sut = SportsBookPresenter()
        mockView = MockSportsBookView()
        mockRouter = MockSportsBookRouter()
        mockInteractor = MockSportsBookInteractor()
        mockInteractor?.output = sut

        sut?.view = mockView
        sut?.interactor = mockInteractor
        sut?.router = mockRouter
        
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
//        mockOutput = nil
        super.tearDown()
    }
    
    func testViewIsLoadingWhileDataNotHere() {
        mockInteractor?.returnImmediately = true
        sut?.viewDidLoad()
        
        XCTAssertTrue(mockView?.loading ?? false)
    }

    func testMatchesNeverReceivedAndErrorIsShown() {
        mockInteractor?.failOnFetchMatches = true
        sut?.viewDidLoad()
        XCTAssertTrue(mockView?.activityError ?? false)
        XCTAssertNil(mockView?.live)
        XCTAssertNil(mockView?.future)
        XCTAssertFalse(mockInteractor?.socketConnected ?? true)
    }

    func testMatchesReceivedCorrectly() {
        sut?.viewDidLoad()
        
        //test view stopped loading
        XCTAssertFalse(mockView?.loading ?? true)
        
        //test the matches where received and split correctly into live and future (fake data contains 1 for each)
        XCTAssertTrue(mockView?.live?.count == 1)
        XCTAssertTrue(mockView?.future?.count == 1)
        
        //test no activity error is shown
        XCTAssertFalse(mockView?.activityError ?? true)
        
        //test socket updates were started
        XCTAssertTrue(mockInteractor?.socketConnected ?? false)
        
        //TODO: THIS MIGHT NEED SOME SECONDS TO RUN 
        //FIX:  MOVE TO SLOW TESTS FILE
        //The maximum time after which both timers in the presentation will have run
        var waitTimeForTimerToRunAtLeastOneForCodeCoverage = Constants.Playbook.Values.liveSecondsTimerInterval
        
        if (Constants.Playbook.Values.fakeUpdatesTimerInterval > waitTimeForTimerToRunAtLeastOneForCodeCoverage)
        {
            waitTimeForTimerToRunAtLeastOneForCodeCoverage = Constants.Playbook.Values.fakeUpdatesTimerInterval
        }
        
        print("RunLoopWillRun for extra: \(waitTimeForTimerToRunAtLeastOneForCodeCoverage)")

        let stopDate = Date(timeIntervalSinceNow: waitTimeForTimerToRunAtLeastOneForCodeCoverage)
        
        //WAIT UNTIL THE TIMER IS REACHED
        RunLoop.current.run(until:stopDate)

        //test match times in view were updated
        XCTAssertTrue(mockView?.timesWereUpdated ?? false)
        
        //test that the update was sent
        XCTAssertNotNil(mockInteractor?.matchToUpdate, "Match to update should not be nil!")
        
        //and received correctly:
        XCTAssertNotNil(mockView?.updatedMatch, "Updated Match should not be nil!")

        //Also check that the update was as expected
        XCTAssertTrue(mockInteractor?.matchToUpdate?.id == mockView?.updatedMatch?.id)
        XCTAssertTrue(mockInteractor?.matchToUpdate?.updateFor == mockView?.updatedMatch?.updateFor)
        XCTAssertTrue(mockInteractor?.matchToUpdate?.value == mockView?.updatedMatch?.value)

        //Test connection is clossed when view is dismissed:
        sut?.viewWillDisappear(true)
        //test socket updates were started
        XCTAssertFalse(mockInteractor?.socketConnected ?? true)

    }

    
}

class MockSportsBookRouter:SportsBookWireframe {
    var viewController: UIViewController?
    
    static func assembleModule() -> UIViewController {
        return UIViewController()
    }
}

class MockSportsBookInteractor:SportsBookUseCase {
    var apiService: ViperNetwork!
    
    var socketService: ViperWebSocket!
    
    var output: SportsBookInteractorOutput!
    
    var socketConnected = false
    
    var returnImmediately = false
    
    var failOnFetchMatches = false
    
    var matchToUpdate:MatchUpdate?
    
    
    func fetchMatches() {
        guard !returnImmediately else { return }
        
        if (failOnFetchMatches) {
            output.matchesFetchFailed("Error fetching matches!")
        } else {
            output.matchesFetched([
                Match(id: 1, live: 1, time: 100, date: "n/a", home: "home", away: "away", homeGoals: 1, awayGoals: 0, bet1: 100, betX: 200, bet2: 300),
                Match(id: 2, live: 0, time: 0, date: "23/02/21", home: "home", away: "away", homeGoals: 0, awayGoals: 0, bet1: 400, betX: 500, bet2: 600),
                ])
        }
    }
    
    func connectToSocketServerForUpdates() {
        socketConnected = true
        output.connectedToSocketServer()
    }
    
    func disconnectFromSocketServer() {
        socketConnected = false
        output.connectionToSocketServerLost()
    }
    
    func fakeUpdateSend(matchToUpdate: MatchUpdate?) {
        
        //Might run multiple times, only process the first time
        if (self.matchToUpdate == nil) {
            self.matchToUpdate = matchToUpdate
            output.updatedMatchReceivedFromSocketServer(updatedMatch: matchToUpdate!)
        }
    }
}

class MockSportsBookView: SportsBookView {
    var presenter: SportsBookPresentation!
    
    var loading = false
    var activityError = false
    
    var live:[Match]?
    var future:[Match]?
    
    var updatedMatch:MatchUpdate?
    
    var timesWereUpdated:Bool = false
    
    
    //var asyncExpectation:XCTestExpectation?

    func showSportsBookData(_ liveMatches: [Match], _ futureMatches: [Match]) {
        self.live = liveMatches
        self.future = futureMatches
    }
    
    func updateSportsBookData(withMatch match: Match, updatedMatch: MatchUpdate, andIndex index: Int) {
        
        //only process the first possible update here:
        if (self.updatedMatch == nil) {
            self.updatedMatch = updatedMatch
        }
    }
    
    func updateLiveMatchesWithNewTimes(_ liveMatches: [Match]) {
        timesWereUpdated = true
    }
}

extension MockSportsBookView: IndicatableView {
    func showActivityError(_ error: String) {
        activityError = true
    }
    
    func showActivityIndicator() {
        loading = true ;
    }
    
    func hideActivityIndicator() {
        loading = false ;
    }
}
