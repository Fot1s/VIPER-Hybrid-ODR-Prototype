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
        view?.showActivityIndicator()
        interactor.fetchMatches()
    }
    
    func viewWillDisappear(_ animated: Bool) {
        if let liveSecondsTimer = liveSecondsTimer {
            liveSecondsTimer.invalidate()
        }
        
        interactor.disconnectFromSocketServer()
        
        #if WITH_SOCKET_UPDATES_EMULATOR
            print("Stoped the emulator from sending any more updates");
            MockSocketServerEmulator.shared.stopSendingEmulatedMatchUpdates()
        #endif
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
        
        
        //update the live matches every second
        //Add a timer to thr current runloop so they work even when the user is interacting
        // only start for liveGames
        
        if (liveMatches.count > 0) {
            liveSecondsTimer = Timer(timeInterval: Constants.Playbook.Values.liveSecondsTimerInterval, target: self, selector: #selector(fireTimerForLiveUpdates), userInfo: nil, repeats: true)
            RunLoop.current.add(liveSecondsTimer!, forMode: .commonModes)
        }
        
        #if WITH_SOCKET_UPDATES_EMULATOR
            print("Running with MockerSocketEmulator! Matches Set")
            MockSocketServerEmulator.shared.liveMatches = live
        #endif

    }
    
    
    func connectedToSocketServer() {
        print("Connection Started!") ;
        
        #if WITH_SOCKET_UPDATES_EMULATOR
            print("Started emulating match updates with an interval of \(Constants.MockSocketServerEmulator.fakeUpdateEvery) seconds");
            MockSocketServerEmulator.shared.startSendingEmulatedMatchUpdates()
        #endif

    }

    @objc func fireTimerForLiveUpdates() {
        for (index,var match) in liveMatches.enumerated() {
            match.time += 1
            
            liveMatches[index] = match
        }
        
        view?.updateLiveMatchesWithNewTimes(self.liveMatches)
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
    }

    internal func matchesFetchFailed(_ error:String) {
        view?.showActivityError(error)
    }
}
