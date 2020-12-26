//
//  SportsBookContract.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 23/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

protocol SportsBookView: IndicatableView {
    var presenter: SportsBookPresentation! { get set }
    
    func showSportsBookData(_ liveMatches: [Match], _ futureMatches: [Match])
    func updateSportsBookData(withMatch match:Match, updatedMatch:MatchUpdate, andIndex index:Int)
    func updateLiveMatchesWithNewTimes(_ liveMatches: [Match])
}

protocol SportsBookPresentation: class {
    weak var view: SportsBookView? { get set }
    var interactor: SportsBookUseCase! { get set }
    var router: SportsBookWireframe! { get set }
    
    func viewDidLoad()
    func viewWillDisappear(_ animated: Bool)
    //    func didSelectMatch(_ match: Match) //TODO: IMPLEMENT NEXT VERSION
}

protocol SportsBookUseCase: class {
    var apiService: ViperNetwork! { get set }
    var socketService: ViperWebSocket! { get set }

    weak var output: SportsBookInteractorOutput! { get set }
    
    func fetchMatches()
    func connectToSocketServerForUpdates()
    func disconnectFromSocketServer()
    func fakeUpdateSend(matchToUpdate: MatchUpdate?) 
}

protocol SportsBookInteractorOutput: class {
    func matchesFetched(_ matches: [Match])
    func matchesFetchFailed(_ error:String)
    func connectedToSocketServer()
    func connectionToSocketServerLost()
    func updatedMatchReceivedFromSocketServer(updatedMatch:MatchUpdate)
}

protocol SportsBookWireframe: class {
    
    weak var viewController: UIViewController? { get set }
    
    //    func presentMatchDetail(forMatch match: Match)//TODO: IMPLEMENT NEXT VERSION
    
    static func assembleModule() -> UIViewController
}
