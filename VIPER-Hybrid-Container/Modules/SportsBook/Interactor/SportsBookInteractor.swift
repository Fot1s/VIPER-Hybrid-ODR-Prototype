//
//  ReactAppsInteractor.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation
import Starscream
import CoreData

class SportsBookInteractor: SportsBookUseCase {

    var sportsBookDataManager: SportsBookDataManager!
    
    weak var output: SportsBookInteractorOutput!

    func fetchMatchesAndSubscribeToLiveUpdates() {

        sportsBookDataManager.getMatches(updatedMatchesHandler: output.updatedMatchReceived,
                                      connectedHandler: output.liveDataAvailable,
                                      disConnectedHandler: output.liveDataNotAvailable
        ) { [weak self] (matches: [Match]?, error: Error?) in
            
            if let `self` = self {
                
                if let matches = matches {
                    self.output.matchesFetched(matches)
                } else {
                    self.output.matchesFetchFailed(error?.localizedDescription ?? "Error getting Matches from MatchesDataManager!")
                }
            }
        }
    }

    func unsubscribeFromLiveUpdates() {
        sportsBookDataManager.unsubscribeFromLiveUpdates()
    }
}
