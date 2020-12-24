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

class APIService {
    
    static let shared = APIService()
    
    private init() {
        
    }

    func fetchMatches(completion: @escaping ([Match]?) -> Void){
        Alamofire
            .request(Endpoints.ReactApps.fetchMatches.url, method: .get)
            .validate()
            .responseArray(completionHandler: { (response: DataResponse<[Match]>) in
                switch response.result {
                case .success(let matches):
                    completion(matches)
                case .failure(let error):
                    print("Error while fetching matches: \(String(describing: error))")
                    completion(nil)
                }
            })
    }
    
    func fetchReactApps(completion: @escaping ([ReactApp]?) -> Void){
        Alamofire
            .request(Endpoints.ReactApps.fetchReactApps.url, method: .get)
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
