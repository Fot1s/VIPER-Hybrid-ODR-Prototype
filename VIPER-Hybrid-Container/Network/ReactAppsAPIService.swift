//
//  ReactAppsAPIService.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 12/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//


import Foundation
import Alamofire
import AlamofireObjectMapper

class ReactAppsAPIService {
    
    static func fetchReactApps(completion: @escaping ([ReactApp]?) -> Void){
        Alamofire
            .request(Endpoints.ReactApps.fetch.url, method: .get)
            .validate()
            .responseArray(completionHandler: { (response: DataResponse<[ReactApp]>) in
                switch response.result {
                case .success(let reactContents):
                    completion(reactContents)
                case .failure(let error):
                    print("Error while fetching react apps: \(String(describing: error))")
                    completion(nil)
                }
            })
    }
}
