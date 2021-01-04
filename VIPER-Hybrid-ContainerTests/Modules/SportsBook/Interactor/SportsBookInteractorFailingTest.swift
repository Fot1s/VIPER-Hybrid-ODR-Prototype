//
//  SportsBookInteractorTest.swift
//  VIPER-Hybrid-ContainerTests
//
//  Created by Fotis Chatzinikos on 25/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import XCTest
import Starscream

@testable import VIPER_Hybrid_Container

/**
 Tests for the SportsBookInteractor that should always Fail
 
 */
class SportsBookInteractorFailingTest: XCTestCase {
    
    var sut: SportsBookInteractor?
    var mockOutput: FailingMockSportsBookInteractorOutput?
    
    override func setUp() {
        super.setUp()
        
        sut = SportsBookInteractor()
        mockOutput = FailingMockSportsBookInteractorOutput()
        
        sut?.apiService = FailingMockAPIService.shared
        sut?.socketService = FailingMockWebSocketService.shared
        sut?.output = mockOutput
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        mockOutput = nil
        super.tearDown()
    }
    
    func testFetchMatchesFails() {
        
        sut?.fetchMatches()

        XCTAssertFalse(mockOutput!.matchesFetched!, "matchesFetched should be false")
        
    }

    //    TODO:
//    func testFakeUpdateSendWithEmptyMatchToUpdateFails() {
//
//        var matchToUpdate:MatchUpdate?
//
//        sut?.fakeUpdateSend(matchToUpdate: matchToUpdate)
//
//        //Just to silence the warning
//        matchToUpdate = MatchUpdate()
//
//        XCTAssertNil(mockOutput!.updatedMatch, "updatedMatch should be false")
//
//    }

    //TODO: Clean up the socketserver
    //FIX:  match should not be sent at all not received!
//    func testFakeUpdateSendWithMatchToUpdateFails() {
//        sut?.connectToSocketServerForUpdates()
//
//        let matchToUpdate:MatchUpdate = MatchUpdate()
//        
//        sut?.fakeUpdateSend(matchToUpdate: matchToUpdate)
//        
//        XCTAssertFalse(mockOutput!.updatedMatch!, "updatedMatch should be false")
//        
//    }

    
    func testConnectToSocketServerFails() {
        sut?.connectToSocketServerForUpdates()
        
//        XCTAssertNotNil(mockOutput!.socketConnected)
        XCTAssertFalse(mockOutput!.socketConnected!)
    }
}

//TODO: Clean up the socketserver
//FIX:

class FailingMockSportsBookInteractorOutput: SportsBookInteractorOutput {
    
    var matchesFetched:Bool?
    var socketConnected:Bool?
    var updatedMatch:Bool?
    
    func matchesFetched(_ matches: [Match]) {
        matchesFetched = true
    }
    
    func matchesFetchFailed(_ error: String) {
        matchesFetched = false
    }
    
    func connectedToSocketServer() {
        socketConnected = true
    }
    
    func connectionToSocketServerLost() {
        socketConnected = false
    }
    
    func updatedMatchReceivedFromSocketServer(updatedMatch: MatchUpdate) {
        self.updatedMatch = false
    }
}

/**
 Always fails by simply calling websocketDidDisconnect on connection
 */

class FailingMockWebSocketService: ViperWebSocket {

    static let shared = FailingMockWebSocketService()
    
    var websocket: WebSocket!
    
    private init() {
        let url = URL(string: "ws://none")!
        let request = URLRequest(url: url)
        
        websocket = WebSocket(request: request)
    }
    
    func connect(withDelegate delegate:WebSocketDelegate) {
        websocket.delegate = delegate
        websocket.delegate?.websocketDidDisconnect(socket: websocket, error: nil)
    }
    
    func write(message: String) {
        websocket.delegate?.websocketDidReceiveMessage(socket: websocket, text: message)
    }
    
    func disconnect() {
        websocket.delegate?.websocketDidDisconnect(socket: websocket, error: nil)
    }
}

/**
 Always fails by simply completing nil
 */
class FailingMockAPIService: ViperNetwork {

    static let shared = FailingMockAPIService()

    private init() {

    }

    //Generic version of fetch no need to have multiple versions as bellow
    func fetch<T>(endPointURL: String, completion: @escaping ([T]?) -> Void) where T:Codable {

        completion(nil)
    }
}

