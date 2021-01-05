//
//  Endpoints.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 12/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation

struct API {
    static let baseUrl = "https://phinnovation.000webhostapp.com/"
    static let baseSocketUrl = "ws://echo.websocket.org"
}

protocol Endpoint {
    var path: String { get }
    var url: String { get }
}

enum Endpoints: Endpoint {

    case reactApps
    case matches
//    case matchUpdatesSocket

    public var path: String {
        switch self {
        case .reactApps: return "/react-apps/"
        case .matches: return "/react-prototype/sportsbook/backend/"
//        case .matchUpdatesSocket: return ""
        }
    }

    public var url: String {
        return "\(API.baseUrl)\(path)"
    }
}

enum SocketEndpoints: Endpoint {

    case matchUpdatesSocket

    public var path: String {
        switch self {
        case .matchUpdatesSocket: return ""
        }
    }

    public var url: String {
        return "\(API.baseSocketUrl)\(path)"
    }
}
