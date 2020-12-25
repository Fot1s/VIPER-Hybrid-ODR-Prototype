//
//  ReactApp.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 12/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation
import ObjectMapper

struct Match {
    var id = 0
    var home = ""
    var away = ""
    var bet_1 = 0
    var bet_x = 0
    var bet_2 = 0
}

//Could be Codable but Mappable works faster with AlamoFire
extension Match: Mappable {
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id      <- map["id"]
        home    <- map["home"]
        away    <- map["away"]
        bet_1    <- map["bet_1"]
        bet_x    <- map["bet_x"]
        bet_2    <- map["bet_2"]
    }
}
