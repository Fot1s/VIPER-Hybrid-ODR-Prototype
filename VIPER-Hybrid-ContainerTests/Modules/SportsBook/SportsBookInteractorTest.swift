//
//  SportsBookInteractorTest.swift
//  VIPER-Hybrid-ContainerTests
//
//  Created by Demitri Delinikolas on 25/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import XCTest
import ObjectMapper
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
        sut?.output = mockOutput
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        mockOutput = nil
        super.tearDown()
    }
    
    func testInteractor() {
        
        sut?.fetchMatches()

        XCTAssertNotNil(mockOutput?.matches, "matches should not be nil")
        let match = mockOutput!.matches![0]
        
        XCTAssertTrue(match.id == 1)
        XCTAssertTrue(match.home == "home")
        XCTAssertTrue(match.away == "away")
        XCTAssertTrue(match.bet1 == 100)
        XCTAssertTrue(match.betX == 200)
        XCTAssertTrue(match.bet2 == 300)
        
        sut?.connectToSocketServerForUpdates()
        
        XCTAssertNotNil(mockOutput!.socketConnected)
        XCTAssertTrue(mockOutput!.socketConnected!)

        let matchToUpdate = MatchUpdate(id: 1, updateFor: .Draw, value: 250)
        
        sut?.fakeUpdateSend(matchToUpdate:matchToUpdate)
        
        XCTAssertNotNil(mockOutput!.updatedMatch)

        let updatedMatch = mockOutput!.updatedMatch
        
        XCTAssertTrue(matchToUpdate.id == updatedMatch?.id)
        XCTAssertTrue(matchToUpdate.updateFor == updatedMatch?.updateFor)
        XCTAssertTrue(matchToUpdate.value == updatedMatch?.value)

        sut?.disconnectFromSocketServer()

        XCTAssertFalse(mockOutput!.socketConnected!)
    }
}

class MockSportsBookInteractorOutput: SportsBookInteractorOutput {
    
    var matches:[Match]?
    var socketConnected:Bool?
    var updatedMatch:MatchUpdate?
    
    func matchesFetched(_ matches: [Match]) {
        self.matches = matches
    }
    
    func matchesFetchFailed(_ error: String) {
        
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

class MockWebSocketService: ViperWebSocket {

    static let shared = MockWebSocketService()
    
    var websocket: WebSocket!
    
    private init() {
        let url = URL(string: "ws://none")!
        let request = URLRequest(url: url)
        
        websocket = WebSocket(request: request)
    }
    
    func connect(withDelegate delegate:WebSocketDelegate) {
        websocket.delegate = delegate
        websocket.delegate?.websocketDidConnect(socket: websocket)
    }
    
    func write(message: String) {
        websocket.delegate?.websocketDidReceiveMessage(socket: websocket, text: message)
    }
    
    func disconnect() {
        websocket.delegate?.websocketDidDisconnect(socket: websocket, error: nil)
    }
}

class MockAPIService: ViperNetwork {

    static let shared = MockAPIService()

    private init() {

    }

    //Generic version of fetch no need to have multiple versions as bellow
    func fetch<T>(endPointURL: String, completion: @escaping ([T]?) -> Void) where T:Codable {

        let matches:[Match]? = [Match(id:1, home:"home", away:"away", bet_1:100,bet_x:200,bet_2:300)]
        completion(matches as? [T])
    }
}

