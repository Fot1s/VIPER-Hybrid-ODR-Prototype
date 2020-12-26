//
//  NetworkProtocol.swift
//  VIPER-Hybrid-Container
//
//  Created by Demitri Delinikolas on 25/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation
import ObjectMapper
import Starscream

protocol ViperNetwork {
    func fetch<T>(endPointURL: String, completion: @escaping ([T]?) -> Void) where T: Mappable
}

protocol ViperWebSocket {
    func connect(withDelegate delegate:WebSocketDelegate)
    
    func write(message: String)
    
    func disconnect()
}

