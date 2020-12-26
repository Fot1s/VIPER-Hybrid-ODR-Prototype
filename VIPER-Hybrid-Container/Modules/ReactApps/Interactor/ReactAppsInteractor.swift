//
//  ReactAppsInteractor.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation
import ObjectMapper

class ReactAppsInteractor: ReactAppsUseCase {
    
    var apiService: APIService!

    weak var output: ReactAppsInteractorOutput!

    func fetchReactApps() {
        apiService.fetch(endPointURL: Endpoints.ReactApps.url) { (reactApps:[ReactApp]?) -> () in
                if let reactApps = reactApps {
                    self.output.reactAppsFetched(reactApps)
                } else {
                    self.output.reactAppsFetchFailed("Error getting ReactApps from Server!")
                }
        }
    }
}
