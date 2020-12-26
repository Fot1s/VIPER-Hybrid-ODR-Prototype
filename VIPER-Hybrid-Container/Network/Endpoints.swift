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
}

protocol Endpoint {
    var path: String { get }
    var url: String { get }
}

enum Endpoints: Endpoint {
    
    case ReactApps
    case Matches

    public var path: String {
        switch self {
        case .ReactApps: return "/react-apps/"
        case .Matches: return "/react-prototype/sportsbook/backend/"
        }
    }
    
    public var url: String {
        return "\(API.baseUrl)\(path)"
    }
}
