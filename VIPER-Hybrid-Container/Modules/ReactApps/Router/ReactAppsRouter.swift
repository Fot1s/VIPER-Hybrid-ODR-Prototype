//
//  ReactAppsRouter.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

class ReactAppsRouter: ReactAppsWireframe {
    
    weak var viewController: UIViewController?

    static func assembleModule() -> UIViewController {
        let view = R.storyboard.reactAppsStoryboard.reactAppsViewController()
        let presenter = ReactAppsPresenter()
        let interactor = ReactAppsInteractor()
        let router = ReactAppsRouter()
        
        let navigation = UINavigationController(rootViewController: view!)
        
        view?.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter
        
        router.viewController = view
        
        return navigation
    }
    
    func presentHybridContent(forReactApp reactApp: ReactApp) {
        let hybridContentViewController = HybridContentRouter.assembleModule(reactApp)
        viewController?.navigationController?.pushViewController(hybridContentViewController, animated: true)
    }

}
