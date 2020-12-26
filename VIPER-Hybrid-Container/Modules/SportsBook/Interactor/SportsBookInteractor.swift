//
//  ReactAppsInteractor.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation
import Starscream

class SportsBookInteractor: SportsBookUseCase {
    
    var apiService: ViperNetwork!
    var socketService: ViperWebSocket!

    weak var output: SportsBookInteractorOutput!

    func fetchMatches() {

        apiService
            .fetch(endPointURL: Endpoints.Matches.url) { (matches:[Match]?) -> () in
                if let matches = matches {
                    self.output.matchesFetched(matches)
                } else {
                    self.output.matchesFetchFailed("Error getting Matches from Server!")
                }
        }

//        apiService
//            .fetchMatches() { matches in
//                if let matches = matches {
//                    self.output.matchesFetched(matches)
//                } else {
//                    self.output.matchesFetchFailed("Error getting Matches from Server!")
//                }
//        }
    }
    
    func connectToSocketServerForUpdates() {
        socketService.connect(withDelegate: self)
    }
    
    func fakeUpdateSend(matchToUpdate: MatchUpdate) {
        
        let encoder = JSONEncoder()
        //encoder.outputFormatting = .prettyPrinted

        do {
            let jsonData = try encoder.encode(matchToUpdate)

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                socketService.write(message: jsonString)
            }
        } catch {
            print(error.localizedDescription)
        }

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
        output.connectionToSocketServerLost()
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        let jsonDecoder = JSONDecoder()

        do {
            let jsonData = text.data(using: .utf8)!
            // Decode data to object

            let updatedMatch = try jsonDecoder.decode(MatchUpdate.self, from: jsonData)

            output.updatedMatchReceivedFromSocketServer(updatedMatch:updatedMatch)
        }
        catch {
            print(error.localizedDescription)
        }

    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {}
    
}
