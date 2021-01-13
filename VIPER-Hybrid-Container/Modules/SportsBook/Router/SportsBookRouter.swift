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
        interactor.sportsBookDataManager = SportsBookDataManager(CoreDataService.shared, APIService.shared, WebSocketService.shared)

        router.viewController = view

        return view!
    }
}
