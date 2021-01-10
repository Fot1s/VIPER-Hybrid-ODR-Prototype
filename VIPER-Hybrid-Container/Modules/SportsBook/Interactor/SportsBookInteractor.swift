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
    
    var storeService: ViperStore!
    var apiService: ViperNetwork!
    var socketService: ViperWebSocket!

    weak var output: SportsBookInteractorOutput!

    func storeUpdatedMatch(match: Match) {
        storeService.upsert(entities: [match]) { [weak self] error in
            self?.output.updatedMatchStored(error: error)
        }
    }

    func fetchMatches() {

        storeService.get { [weak self] (matches: [Match]?, error: Error?) in
            
            if let `self` = self {
                
                if let matches = matches {
                    
                    if matches.count > 0 {
                        
                        print("Saved matches found returning")
                        //saved data return and do not call network
                        self.output.matchesFetched(matches)
                        return
                    } else {
                        
                        //no matches //first call // fetch from net
                        self.apiService
                            .fetch(endPointURL: Endpoints.matches.url) { [weak self] (matches: [Match]?) -> Void in
                                
                                if let `self` = self {
                                    if let matches = matches {
                                        
                                        self.storeService.upsert(entities: matches) { error in
                                            if let error = error {
                                                print("Error saving / updating data! \(error)")
                                            }
                                        }
                                        
                                        self.output.matchesFetched(matches)
                                    } else {
                                        self.output.matchesFetchFailed("Error getting Matches from Server!")
                                    }
                                    
                                }
                        }
                    }
                    
                } else {
                    self.output.matchesFetchFailed(error?.localizedDescription ?? "Error getting Matches from Core Data!")
                }
            }
        }
    }

    func connectToSocketServerForUpdates() {
        socketService.connect(withDelegate: self)
    }

    func disconnectFromSocketServer() {
        socketService.disconnect()
    }
}

extension SportsBookInteractor: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        output.connectedToSocketServer()
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print(error?.localizedDescription ?? "Missing Error!")
        output.connectionToSocketServerLost()
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {

        let jsonDecoder = JSONDecoder()

        do {
            let jsonData = text.data(using: .utf8)!
            // Decode data to object

            let updatedMatch = try jsonDecoder.decode(MatchUpdate.self, from: jsonData)

            output.updatedMatchReceivedFromSocketServer(updatedMatch: updatedMatch)
        } catch {
            print(error.localizedDescription)
        }

    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {}

}
