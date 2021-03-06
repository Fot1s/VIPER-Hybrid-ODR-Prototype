//
//  NetworkProtocol.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 25/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation
import Starscream

protocol ViperNetwork {
    func fetch<T>(endPointURL: String, completion: @escaping ([T]?) -> Void) where T: Codable
}

protocol ViperWebSocket {
    func connect(withDelegate delegate: WebSocketDelegate)

    func write(message: String)

    func disconnect()
}
