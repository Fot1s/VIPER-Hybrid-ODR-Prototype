//
//  SportsBookPresenter.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 23/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

class SportsBookPresenter: SportsBookPresentation {

    weak var view: SportsBookView?
    var interactor: SportsBookUseCase!
    var router: SportsBookWireframe!
    
    var fakeUpdatesTimer:Timer?
    var liveSecondsTimer:Timer?

    var liveMatches: [Match] = []
    var futureMatches: [Match] = []
//    {
//        didSet {
//            if matches.count > 0 {
//                view?.showSportsBookData(matches)
//            }
//        }
//    }
    
    func viewDidLoad() {
        interactor.fetchMatches()
        view?.showActivityIndicator()
    }
    
    func viewWillDisappear(_ animated: Bool) {
        if let timer = fakeUpdatesTimer {
            timer.invalidate()
        }
        
        if let liveSecondsTimer = liveSecondsTimer {
            liveSecondsTimer.invalidate()
        }
        
        interactor.disconnectFromSocketServer()
    }
}

extension SportsBookPresenter: SportsBookInteractorOutput {
    
    func matchesFetched(_ matches: [Match]) {
        
        var live:[Match] = []
        var future:[Match] = []

        for match in matches {
            if (match.live == 1) {
                live.append(match)
            } else {
                future.append(match)
            }
        }
        
        self.liveMatches = live
        self.futureMatches = future

        view?.showSportsBookData(self.liveMatches, self.futureMatches)
        view?.hideActivityIndicator()
        interactor.connectToSocketServerForUpdates()
    }
    
    
    func connectedToSocketServer() {
        print("Connection Started!") ;
        
        //Add a timer to thr current runloop so they work even when the user is interacting
        // only start for liveGames
        
        if (liveMatches.count > 0) {
            fakeUpdatesTimer = Timer(timeInterval: 5.0, target: self, selector: #selector(fireTimerForFakeUpdates), userInfo: nil, repeats: true)
            RunLoop.current.add(fakeUpdatesTimer!, forMode: .commonModes)

            liveSecondsTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(fireTimerForLiveUpdates), userInfo: nil, repeats: true)
            RunLoop.current.add(liveSecondsTimer!, forMode: .commonModes)

        }
        
    }

    @objc func fireTimerForLiveUpdates() {
        for (index,var match) in liveMatches.enumerated() {
            match.time += 1
            
            liveMatches[index] = match
        }
        
        view?.updateLiveMatchesWithNewTimes(self.liveMatches)
    }
    
    @objc func fireTimerForFakeUpdates() {
        
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
        
        interactor.fakeUpdateSend(matchToUpdate: matchToUpdate)
    }
    
    func connectionToSocketServerLost() {
        //TODO: IMPLEMENT RECONNECTION HERE
        print("Connection Dropped!") ;
    }
    
    func updatedMatchReceivedFromSocketServer(updatedMatch:MatchUpdate){
        //TODO:IMPLEMENT TABLE UPDATE
//        print("Updated received: \(updatedMatch)")
        
        if let oldMatchIndex = self.liveMatches.index(where: { matchFromArray in
            return (matchFromArray.id == updatedMatch.id)
        }) {
            var match = self.liveMatches[oldMatchIndex]
            
            switch (updatedMatch.updateFor) {
            case .Home :
                match.bet1 = updatedMatch.value
            case .Draw :
                match.betX = updatedMatch.value
            case .Away :
                match.bet2 = updatedMatch.value
            }
            
            self.liveMatches[oldMatchIndex] = match
            view?.updateSportsBookData(withMatch: match, updatedMatch: updatedMatch, andIndex: oldMatchIndex)
        }
        
//        if var match = matches.first(where: { $0.id == updatedMatch.id}){
//            print("Match Found: \(match)" )
//
//            switch (updatedMatch.updateFor) {
//            case .Home :
//                match.bet_1 = updatedMatch.value
//            case .Draw :
//                match.bet_x = updatedMatch.value
//            case .Away :
//                match.bet_2 = updatedMatch.value
//            }
//
//            view?.updateSportsBookData(withMatch: match)
//
//        } else {
//            print("Game not found! \(updatedMatch)")
//        }
        
    }

    internal func matchesFetchFailed(_ error:String) {
        view?.showActivityError(error)
    }
}
