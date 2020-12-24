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
    
    var apiService: APIService!
    var socketService: WebSocketTestService!

    weak var output: SportsBookInteractorOutput!

    func fetchMatches() {
        let match = Match(id:1, home: "Olympiakos", away: "Panathinaikos", bet_1:200, bet_x:300,bet_2:400)
        let match2 = Match(id:2, home: "Oly2", away: "Pan2", bet_1:1200, bet_x:1300,bet_2:1400)
        let match6 = Match(id:3, home: "Oly2", away: "Pan2", bet_1:1200, bet_x:1300,bet_2:1400)
        let match3 = Match(id:4, home: "Oly2", away: "Pan2", bet_1:1200, bet_x:1300,bet_2:1400)
        let match4 = Match(id:5, home: "Oly2", away: "Pan2", bet_1:1200, bet_x:1300,bet_2:1400)
        let match5 = Match(id:6, home: "Oly2", away: "Pan2", bet_1:1200, bet_x:1300,bet_2:1400)
        let match7 = Match(id:7, home: "Oly2", away: "Pan2", bet_1:1200, bet_x:1300,bet_2:1400)
        let match8 = Match(id:8, home: "Oly2", away: "Pan2", bet_1:1200, bet_x:1300,bet_2:1400)
        let match9 = Match(id:9, home: "Oly2", away: "Pan2", bet_1:1200, bet_x:1300,bet_2:1400)
        self.output.matchesFetched([match,match2,match3,match4,match5,match6,match7,match8,match9])
//        apiService
//            .fetchMatches() { matches in
//                if let matches = matches {
//                    matchesFetched(matches)
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
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Data: \(data)")
    }
    
}
