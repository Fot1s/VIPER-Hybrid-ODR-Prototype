//
//  NetworkProtocol.swift
//  VIPER-Hybrid-Container
//
//  Created by Demitri Delinikolas on 25/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation
import ObjectMapper

protocol Network {
    func fetch<T>(endPointURL: String, completion: @escaping ([T]?) -> Void) where T: Mappable
}
