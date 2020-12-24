//
//  SportsBookRouter.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 23/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

class SportsBookRouter: SportsBookWireframe {
    
    weak var viewController: UIViewController?

    static func assembleModule() -> UIViewController {
        let view = R.storyboard.sportsBookStoryboard.sportsBookViewController()
        let presenter = SportsBookPresenter()
        let interactor = SportsBookInteractor()
        let router = SportsBookRouter()
        
        view?.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter
        interactor.apiService = APIService.shared
        interactor.socketService = WebSocketTestService.shared
        
        router.viewController = view
        
        return view!
    }
    
//    func presentHybridContent(forReactApp reactApp: ReactApp) {
//        let hybridContentViewController = HybridContentRouter.assembleModule(reactApp)
//        viewController?.navigationController?.pushViewController(hybridContentViewController, animated: true)
//    }
//
}
