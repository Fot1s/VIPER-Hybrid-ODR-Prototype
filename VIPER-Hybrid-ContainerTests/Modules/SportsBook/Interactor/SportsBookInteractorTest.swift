//
//  SportsBookInteractorTest.swift
//  VIPER-Hybrid-ContainerTests
//
//  Created by Fotis Chatzinikos on 25/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import XCTest
//import ObjectMapper
import Starscream

@testable import VIPER_Hybrid_Container

class SportsBookInteractorTest: XCTestCase {

    var sut: SportsBookInteractor?
    var mockOutput: MockSportsBookInteractorOutput?

    override func setUp() {
        super.setUp()

        sut = SportsBookInteractor()
        mockOutput = MockSportsBookInteractorOutput()

        sut?.apiService = MockAPIService.shared
        sut?.socketService = MockWebSocketService.shared
        sut?.storeService = MockCoreDataService.shared

        sut?.output = mockOutput
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        mockOutput = nil
        super.tearDown()
    }

    func testFetchMatchesFailsCoreData() {
        MockCoreDataService.shared.failOnFetchMatches = true
        sut?.fetchMatches()

        XCTAssertNotNil(mockOutput?.matchesFailedWithError, "matchesFailedWithError should not be nil")
    }

    func testFetchMatchesFailsNet() {
        MockCoreDataService.shared.failOnFetchMatches = false
        MockCoreDataService.shared.returnEmpty = true
        MockAPIService.shared.failOnFetchMatches = true
        sut?.fetchMatches()
        
        XCTAssertNotNil(mockOutput?.matchesFailedWithError, "matchesFailedWithError should not be nil")
    }

    func testFetchMatchesFromCoreData() {
        MockCoreDataService.shared.failOnFetchMatches = false
        MockCoreDataService.shared.returnEmpty = false
        MockAPIService.shared.failOnFetchMatches = false
        sut?.fetchMatches()
        
        XCTAssertNotNil(mockOutput?.matches, "matches should not be nil")
        XCTAssertTrue(mockOutput?.matches?.count == 1)
    }

    func testFetchMatchesNet() {
        MockCoreDataService.shared.failOnFetchMatches = false
        MockCoreDataService.shared.returnEmpty = true
        MockAPIService.shared.failOnFetchMatches = false

        //fetch matches - MockAPIService will return 1 match
        sut?.fetchMatches()

        XCTAssertNotNil(mockOutput?.matches, "matches should not be nil")
        XCTAssertTrue(mockOutput?.matches?.count == 1)
        let match = mockOutput!.matches![0]

        XCTAssertTrue(match.id == 1)
        XCTAssertTrue(match.live == 1)
        XCTAssertTrue(match.time == 300)
        XCTAssertTrue(match.date == "n/a")
        XCTAssertTrue(match.home == "home")
        XCTAssertTrue(match.away == "away")
        XCTAssertTrue(match.homeGoals == 0)
        XCTAssertTrue(match.awayGoals == 0)
        XCTAssertTrue(match.bet1 == 100)
        XCTAssertTrue(match.betX == 200)
        XCTAssertTrue(match.bet2 == 300)
    }

    func testConnectToSocketServerFails() {

        MockWebSocketService.shared.failToConnect = true
        sut?.connectToSocketServerForUpdates()

        XCTAssertNotNil(mockOutput?.socketConnected)
        XCTAssertFalse(mockOutput?.socketConnected ?? true)
    }

    func testConnectAndDisconnectFromSocketServer() {
        //test connection
        sut?.connectToSocketServerForUpdates()

        XCTAssertNotNil(mockOutput?.socketConnected)
        XCTAssertTrue(mockOutput?.socketConnected ?? false)

        //test disconnection
        sut?.disconnectFromSocketServer()

        XCTAssertFalse(mockOutput?.socketConnected ?? true)
    }

    func testConnectToSocketSendAndReceiveAMatchUpdate() {

        //connection
        sut?.connectToSocketServerForUpdates()

        //test an update
        let matchToUpdate = MatchUpdate(id: 1, updateFor: .draw, value: 250)

        MockWebSocketService.shared.fakeUpdateSend(matchToUpdate: matchToUpdate)
        XCTAssertNotNil(mockOutput?.updatedMatch)

        let updatedMatch = mockOutput?.updatedMatch

        XCTAssertTrue(matchToUpdate.id == updatedMatch?.id)
        XCTAssertTrue(matchToUpdate.updateFor == updatedMatch?.updateFor)
        XCTAssertTrue(matchToUpdate.value == updatedMatch?.value)
    }

}

class MockSportsBookInteractorOutput: SportsBookInteractorOutput {

    var matches: [Match]?
    var socketConnected: Bool?
    var updatedMatch: MatchUpdate?
    var matchesFailedWithError: String?

    func matchesFetched(_ matches: [Match]) {
        self.matches = matches
    }

    func matchesFetchFailed(_ error: String) {
        self.matchesFailedWithError = error
    }

    func connectedToSocketServer() {
        socketConnected = true
    }

    func connectionToSocketServerLost() {
        socketConnected = false
    }

    func updatedMatchReceivedFromSocketServer(updatedMatch: MatchUpdate) {
        self.updatedMatch = updatedMatch
    }
}

class MockCoreDataService: ViperStore {
  
    enum MyError: Error {
        case runtimeError(String)
    }
    static let shared = MockCoreDataService()
    
    var failOnFetchMatches = false
    var returnEmpty = false

    func delete<Entity>(_ type: Entity.Type) where Entity: ManagedObjectConvertible {
    }
    
    func get<Entity>(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?,
                     completion: @escaping ([Entity]?, Error?) -> Void) where Entity: ManagedObjectConvertible {
        
        if failOnFetchMatches {
            completion(nil, nil)
        } else {
            let matches: [Match]? = [Match(id: 1, live: 1, time: 300, date: "n/a", home: "home", away: "away",
                                           homeGoals: 0, awayGoals: 0, bet1: 100, betX: 200, bet2: 300)]
            
            let emptyMatches = [Match]()
            
            if returnEmpty {
                completion(emptyMatches as? [Entity], nil)
            } else {
                completion(matches as? [Entity], nil)
            }
        }
    }
    
    func upsert<Entity>(entities: [Entity], completion: @escaping (Error?) -> Void) where Entity: ManagedObjectConvertible {
        //just for code coverage

        completion(MyError.runtimeError("Test"))
    }
}

class MockWebSocketService: ViperWebSocket {

    static let shared = MockWebSocketService()

    var websocket: WebSocket!

    var failToConnect = false

    private init() {
        let url = URL(string: "ws://none")!
        let request = URLRequest(url: url)

        websocket = WebSocket(request: request)
    }

    func connect(withDelegate delegate: WebSocketDelegate) {
        websocket.delegate = delegate

        if failToConnect {
            websocket.delegate?.websocketDidDisconnect(socket: websocket, error: nil)
        } else {
            websocket.delegate?.websocketDidConnect(socket: websocket)

            //Just for test coverage:
            //send an empty Data
            websocket.delegate?.websocketDidReceiveData(socket: websocket, data: Data())
            //send a broken json text
            websocket.delegate?.websocketDidReceiveMessage(socket: websocket, text: "broken")
        }
    }

    func write(message: String) {
        websocket.delegate?.websocketDidReceiveMessage(socket: websocket, text: message)
    }

    func disconnect() {
        websocket.delegate?.websocketDidDisconnect(socket: websocket, error: nil)
    }

    func fakeUpdateSend(matchToUpdate: MatchUpdate?) {

        let encoder = JSONEncoder()

        do {
            let jsonData = try encoder.encode(matchToUpdate)

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                write(message: jsonString)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

}

class MockAPIService: ViperNetwork {

    static let shared = MockAPIService()

    var failOnFetchMatches = false

    private init() {

    }

    func fetch<T>(endPointURL: String, completion: @escaping ([T]?) -> Void) where T: Codable {
        if failOnFetchMatches {
            completion(nil)
        } else {
            let matches: [Match]? = [Match(id: 1, live: 1, time: 300, date: "n/a", home: "home", away: "away",
                                           homeGoals: 0, awayGoals: 0, bet1: 100, betX: 200, bet2: 300)]
            completion(matches as? [T])
        }
    }
}
