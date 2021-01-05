//
//  ReactApp.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 12/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation
//import ObjectMapper

struct Match: Codable {
    var id = 0
    var live = 0
    var time = 0
    var date = "20/12/20"
    var home = ""
    var away = ""
    var homeGoals = 0
    var awayGoals = 0
    var bet1 = 0
    var betX = 0
    var bet2 = 0

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case live = "live"
        case time = "time"
        case date = "date"
        case home = "home"
        case away = "away"
        case homeGoals = "home_goals"
        case awayGoals = "away_goals"
        case bet1 = "bet_1"
        case betX = "bet_x"
        case bet2 = "bet_2"
    }

}

//Switched To Codable after all :)
//Could be Codable but Mappable works out of the box with AlamoFire
//extension Match: Mappable {
//
//    init?(map: Map) {
//    }
//
//    mutating func mapping(map: Map) {
//        id      <- map["id"]
//        home    <- map["home"]
//        away    <- map["away"]
//        bet_1    <- map["bet_1"]
//        bet_x    <- map["bet_x"]
//        bet_2    <- map["bet_2"]
//    }
//}
