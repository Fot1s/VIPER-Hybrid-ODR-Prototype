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
import ObjectMapper

class APIService: Network {
    
    static let shared = APIService()
    
    private init() {
        
    }
    
    //Generic version of fetch no need to have multiple versions as bellow
    func fetch<T>(endPointURL: String, completion: @escaping ([T]?) -> Void) where T: Mappable {
        Alamofire
            .request(endPointURL, method: .get)
            .validate()
            .responseArray(completionHandler: { (response: DataResponse<[T]>) in
                switch response.result {
                case .success(let elements):
                    completion(elements )
                case .failure(let error):
                    print("Error while fetching elements: \(String(describing: error))")
                    completion(nil)
                }
            })
    }

    
//    func fetchMatches(completion: @escaping ([Match]?) -> Void){
//        Alamofire
//            .request(Endpoints.ReactApps.fetchMatches.url, method: .get)
//            .validate()
//            .responseArray(completionHandler: { (response: DataResponse<[Match]>) in
//                switch response.result {
//                case .success(let matches):
//                    completion(matches)
//                case .failure(let error):
//                    print("Error while fetching matches: \(String(describing: error))")
//                    completion(nil)
//                }
//            })
//    }
//    
//    func fetchReactApps(completion: @escaping ([ReactApp]?) -> Void){
//        Alamofire
//            .request(Endpoints.ReactApps.fetchReactApps.url, method: .get)
//            .validate()
//            .responseArray(completionHandler: { (response: DataResponse<[ReactApp]>) in
//                switch response.result {
//                case .success(let reactContents):
//                    completion(reactContents)
//                case .failure(let error):
//                    print("Error while fetching react apps: \(String(describing: error))")
//                    completion(nil)
//                }
//            })
//    }
}
