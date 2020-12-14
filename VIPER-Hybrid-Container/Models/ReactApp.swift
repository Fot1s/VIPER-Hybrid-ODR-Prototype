//
//  ReactApp.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 12/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation
import ObjectMapper

struct ReactApp {
    var title = ""
    var imageUrl = ""
    var localPath = ""
}

extension ReactApp: Mappable {
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        title       <- map["title"]
        imageUrl    <- map["image"]
        localPath    <- map["path"]
    }
}
