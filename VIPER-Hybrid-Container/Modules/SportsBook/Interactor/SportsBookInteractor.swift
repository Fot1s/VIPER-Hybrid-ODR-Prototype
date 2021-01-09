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

    func fetchMatches() {

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MatchMO")
        
        do {
            let matchesMO = try storeService.viewContext.fetch(fetchRequest)
            
            if matchesMO.count > 0 {
                print("Database Matches: \(matchesMO)  return cached data now")
                
                var matches = [Match]()
                
                var match: Match
                
                for matchMO in matchesMO {
                    
                    match = Match(id: matchMO.value(forKey: "id") as! Int, live: matchMO.value(forKey: "live") as! Int,
                                  time: matchMO.value(forKey: "time") as! Int, date: matchMO.value(forKey: "date") as! String,
                                  home: matchMO.value(forKey: "home") as! String, away: matchMO.value(forKey: "away") as! String,
                                  homeGoals: matchMO.value(forKey: "homeGoals") as! Int,
                                  awayGoals: matchMO.value(forKey: "awayGoals") as! Int,
                                  bet1: matchMO.value(forKey: "bet1") as! Int, betX: matchMO.value(forKey: "betX") as! Int,
                                  bet2: matchMO.value(forKey: "bet2") as! Int)
                    matches.append(match)
                }
                
                self.output.matchesFetched(matches)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        apiService
            .fetch(endPointURL: Endpoints.matches.url) { [weak self] (matches: [Match]?) -> Void in

                guard let `self` = self else {
                    print("returning, self was deallocated")
                    return
                }

                if let matches = matches {

                    //save test here
                    for match in matches {
                        let newMatch = NSEntityDescription.insertNewObject(forEntityName: "MatchMO", into: self.storeService.viewContext)
                        newMatch.setValue(match.id, forKey: "id")
                        newMatch.setValue(match.date, forKey: "date")
                        newMatch.setValue(match.live, forKey: "live")
                        newMatch.setValue(match.time, forKey: "time")
                        newMatch.setValue(match.home, forKey: "home")
                        newMatch.setValue(match.away, forKey: "away")
                        newMatch.setValue(match.homeGoals, forKey: "homeGoals")
                        newMatch.setValue(match.awayGoals, forKey: "awayGoals")
                        newMatch.setValue(match.bet1, forKey: "bet1")
                        newMatch.setValue(match.betX, forKey: "betX")
                        newMatch.setValue(match.bet2, forKey: "bet2")
                    }
                    do {
                        try self.storeService.viewContext.save()
                        print("Success")
                    } catch {
                        print("Error saving: \(error)")
                    }
                    
                    self.output.matchesFetched(matches)
                } else {
                    self.output.matchesFetchFailed("Error getting Matches from Server!")
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
