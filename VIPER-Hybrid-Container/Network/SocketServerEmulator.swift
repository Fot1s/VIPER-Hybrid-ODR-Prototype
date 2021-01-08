//
//  MockSocketServerEmulator.swift
//  VIPER-Hybrid-Container
//
//  Created by Demitri Delinikolas on 04/01/2021.
//  Copyright © 2021 Fotis Chatzinikos. All rights reserved.
//

import Foundation

class SocketServerEmulator {

    static let shared = SocketServerEmulator()

    private init() {

    }

    var liveMatches: [Match]?

    fileprivate var fakeUpdatesTimer: Timer?

    func startSendingEmulatedMatchUpdates() {
        if (liveMatches?.count ?? 0) > 0 {
            fakeUpdatesTimer = Timer(timeInterval: Constants.SocketServerEmulator.fakeUpdateEvery,
                                     target: self, selector: #selector(fireTimerForFakeUpdates), userInfo: nil, repeats: true)
        RunLoop.current.add(fakeUpdatesTimer!, forMode: .commonModes)
        } else {
            print("Error! Did you forget to set the liveMatches before calling?")
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

            let updateFor = MatchUpdate.BetType(rawValue: whichBet)

            var value = match.getBetValueForBetType(updateFor!)

            //add a random ammount between -5 and 5 to the value:

            var change = 0

            //avoid a change of 0
            repeat {
                change = -5 + Int(arc4random_uniform(11)) //0 to 10 minus -5 is our range
            } while (change == 0)

            value += change

            //do not allow for less than 100
            if value < 100 {
                value = 100
            }

            let matchToUpdate = MatchUpdate(id: match.id, updateFor: MatchUpdate.BetType(rawValue: whichBet)!, value: value)

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
    enum SocketServerEmulator {
        static let fakeUpdateEvery = Double(1) //seconds
    }
}
