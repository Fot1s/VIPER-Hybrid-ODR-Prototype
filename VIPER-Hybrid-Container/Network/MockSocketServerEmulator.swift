//
//  MockSocketServerEmulator.swift
//  VIPER-Hybrid-Container
//
//  Created by Demitri Delinikolas on 04/01/2021.
//  Copyright © 2021 Fotis Chatzinikos. All rights reserved.
//

import Foundation

class MockSocketServerEmulator {
    
    static let shared = MockSocketServerEmulator()
    
    private init() {
        
    }
    
    var liveMatches:[Match]?
    
    fileprivate var fakeUpdatesTimer:Timer?
    
    func startSendingEmulatedMatchUpdates() {
        if (liveMatches?.count ?? 0 > 0) {
            fakeUpdatesTimer = Timer(timeInterval: Constants.MockSocketServerEmulator.fakeUpdateEvery, target: self, selector: #selector(fireTimerForFakeUpdates), userInfo: nil, repeats: true)
        RunLoop.current.add(fakeUpdatesTimer!, forMode: .commonModes)
        }
    }
    
    func stopSendingEmulatedMatchUpdates() {
        if let fakeUpdatesTimer = fakeUpdatesTimer {
            fakeUpdatesTimer.invalidate()
        }
    }
    
    @objc fileprivate func fireTimerForFakeUpdates() {
        
        if let liveMatches = liveMatches {
            let whichMatchId = arc4random_uniform(UInt32(liveMatches.count))
            
            let whichBet = Int(arc4random_uniform(3)+1) //UpdateFor,rawValues: 1,2,3
            
            let match = liveMatches[Int(whichMatchId)]
            
            var value = 0
            
            switch whichBet {//1,2,3
            case 1:
                value = match.bet1
            case 2:
                value = match.betX
            case 3:
                value = match.bet2
            default:
                value = 0
                print("Error: Should not be here")
            }
            
            //add a random ammount between -5 and 5 to the value:
            let change = -5 + Int(arc4random_uniform(11)) //0 to 10 minus -5 is our range
            
            //change might be 0 - skip
            if (change == 0 ) {
                //print("skipping for 0 change");
                return
            }
            //        else {
            //            print("change: \(change)");
            //        }
            
            value += change
            
            //do not allow for less than 100
            if (value < 100) {
                value = 100
            }
            
            let matchToUpdate = MatchUpdate(id: match.id, updateFor:MatchUpdate.UpdateFor(rawValue:whichBet)!, value:value)
            
            fakeUpdateSend(matchToUpdate: matchToUpdate)
        }
    }
    
    fileprivate func fakeUpdateSend(matchToUpdate: MatchUpdate?) {
        
        let encoder = JSONEncoder()
        //encoder.outputFormatting = .prettyPrinted
        
        do {
            let jsonData = try encoder.encode(matchToUpdate)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                WebSocketService.shared.write(message: jsonString)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

}

extension Constants {
    enum MockSocketServerEmulator {
        static let fakeUpdateEvery = Double(1) //seconds
    }
}
