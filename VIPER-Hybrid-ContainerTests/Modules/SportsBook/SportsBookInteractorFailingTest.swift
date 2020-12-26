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
    
    func testInteractor() {
        
        sut?.fetchMatches()

        XCTAssertNil(mockOutput?.matches, "matches should be nil")
        
        sut?.connectToSocketServerForUpdates()
        
        XCTAssertNotNil(mockOutput!.socketConnected)
        XCTAssertFalse(mockOutput!.socketConnected!)
    }
}

class FailingMockSportsBookInteractorOutput: SportsBookInteractorOutput {
    
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

class FailingMockAPIService: ViperNetwork {

    static let shared = FailingMockAPIService()

    private init() {

    }

    //Generic version of fetch no need to have multiple versions as bellow
    func fetch<T>(endPointURL: String, completion: @escaping ([T]?) -> Void) where T:Mappable {

        completion(nil)
    }
}

