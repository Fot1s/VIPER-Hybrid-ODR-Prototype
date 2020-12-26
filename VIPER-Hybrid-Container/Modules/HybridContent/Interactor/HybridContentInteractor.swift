//
//  HybridContentInteractor.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation

class HybridContentInteractor: HybridContentUseCase {
    
    //CAUGHT WITH INSTRUMENTS NEEDS weak!
    weak var output: HybridContentInteractorOutput!
    
    private var request: NSBundleResourceRequest!
    
    func fetchReactAppODR(_ stringTag: String) {
        request = NSBundleResourceRequest(tags: [stringTag])
        
        request.conditionallyBeginAccessingResources(completionHandler: { resourcesAvailable in
            
            if resourcesAvailable {
                OperationQueue.main.addOperation({ [weak self] in

                    self?.output.reactAppODRAvailable(stringTag)
                })
            } else {
                self.request.beginAccessingResources(completionHandler: { error in
                    
                    //not main here switch to main thread:
                    OperationQueue.main.addOperation({ [weak self] in
                        guard error == nil else {
                            self?.output.reactAppODRFetchFailed(error!.localizedDescription)
                            return
                        }
                        
                        //all well load game
                        self?.output.reactAppODRAvailable(stringTag)
                    })
                })
            }
        })
        
    }
}
