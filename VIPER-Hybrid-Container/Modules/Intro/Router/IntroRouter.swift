//
//  ReactAppsRouter.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

class IntroRouter: IntroWireframe {
    
    weak var viewController: UIViewController?

    static func assembleModule() -> UIViewController {
        let view = R.storyboard.introStoryboard.introViewController()
        let presenter = IntroPresenter()
        let router = IntroRouter()
        
        let navigation = UINavigationController(rootViewController: view!)
        
        view?.presenter = presenter

        presenter.view = view 
        presenter.router = router

        router.viewController = view
        
        return navigation
    }
    
    func presentReactApps() {
        let reactAppsViewController = ReactAppsRouter.assembleModule()
        viewController?.navigationController?.pushViewController(reactAppsViewController, animated: true)
    }
    
    func presentSportsBook() {
        //TODO: Implement when new module is ready
//        let sportsBookViewController = SportsBookRouter.assembleModule()
//        viewController?.navigationController?.pushViewController(sportsBookViewController, animated: true)
    }
}
