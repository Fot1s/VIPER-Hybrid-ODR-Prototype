//
//  WebSocketTestService.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 23/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation
import Starscream

class WebSocketService: ViperWebSocket {

    static let shared = WebSocketService()

    var websocket: WebSocket!

    private init() {
        let url = URL(string: SocketEndpoints.matchUpdatesSocket.url)!
        let request = URLRequest(url: url)

        websocket = WebSocket(request: request)
    }

    func connect(withDelegate delegate: WebSocketDelegate) {
        websocket.delegate = delegate
        websocket.connect()
    }

    func write(message: String) {
        websocket.write(string: message)
    }

    func disconnect() {
        websocket.disconnect()
    }
}
