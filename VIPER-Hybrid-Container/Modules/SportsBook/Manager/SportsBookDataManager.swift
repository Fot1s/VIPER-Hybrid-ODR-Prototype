//
//  MatchesDataManager.swift
//  VIPER-Hybrid-Container
//
//  Created by Demitri Delinikolas on 12/01/2021.
//  Copyright © 2021 Fotis Chatzinikos. All rights reserved.
//

import Foundation
import Starscream

class SportsBookDataManager {

    private var storeService: ViperStore
    private var apiService: ViperNetwork
    private var socketService: ViperWebSocket
    
    private var updatedMatchesHandler: ((_ updatedMatch: MatchUpdate) -> Void)?
    private var connectedHandler: (() -> Void)?
    private var disConnectedHandler: (() -> Void)?

    private var cachedMatches: [Match]?
    
    init (_ storeService: ViperStore, _ apiService: ViperNetwork, _ socketService: ViperWebSocket) {
        self.storeService = storeService
        self.apiService  = apiService
        self.socketService = socketService
    }

    func getMatches(updatedMatchesHandler: @escaping (_ updatedMatch: MatchUpdate) -> Void,
                    connectedHandler: @escaping () -> Void,
                    disConnectedHandler: @escaping () -> Void,
                    completion: @escaping ([Match]?, Error?) -> Void) {
        
        self.updatedMatchesHandler = updatedMatchesHandler
        self.connectedHandler = connectedHandler
        self.disConnectedHandler = disConnectedHandler
        
        storeService.get { [weak self] (matches: [Match]?, error: Error?) in
            
            if let `self` = self {
                
                if let matches = matches {
                    
                    self.cachedMatches = matches
                    
                    if matches.count > 0 {
                        
                        print("Saved matches found returning")
                        //saved data return and do not call network
                        completion(matches, nil)
                        self.socketService.connect(withDelegate: self)
                    } else {
                        
                        //no matches //first call // fetch from net
                        self.apiService.fetch(endPointURL: Endpoints.matches.url) { [weak self] (matches: [Match]?) -> Void in
                            
                            if let `self` = self {
                                if let matches = matches {
                                    
                                    self.cachedMatches = matches

                                    self.storeService.upsert(entities: matches) { error in
                                        if let error = error {
                                            print("Error saving / updating data! \(error)")
                                        }
                                    }
                                    
                                    completion(matches, nil)
                                    self.socketService.connect(withDelegate: self)
                                } else {
                                    completion(nil, error)
                                }
                            }
                        }
                    }
                } else {
                    completion(nil, error)
                }
            }
        }
    }
    
    func unsubscribeFromLiveUpdates() {
        self.updatedMatchesHandler = nil
        self.connectedHandler = nil
        self.disConnectedHandler = nil
        
        socketService.disconnect()
    }
}

extension SportsBookDataManager: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        if let connectedHandler = connectedHandler {
            connectedHandler()
        }
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print(error?.localizedDescription ?? "Missing Error!")
        if let disConnectedHandler = disConnectedHandler {
            disConnectedHandler()
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        let jsonDecoder = JSONDecoder()
        
        do {
            let jsonData = text.data(using: .utf8)!
            // Decode data to object
            
            let matchUpdate = try jsonDecoder.decode(MatchUpdate.self, from: jsonData)

            if var matchToUpdate = self.cachedMatches?.first(where: { $0.id == matchUpdate.id }) {
                matchToUpdate.updateMatchBetFromMatchUpdate(matchUpdate)
                storeService.upsert(entities: [matchToUpdate]) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }

            if let updatedMatchesHandler = updatedMatchesHandler {
                updatedMatchesHandler(matchUpdate)
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {}
    
}
