//
//  HybridContentRouter.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

class HybridContentRouter: HybridContentWireframe {

    static func assembleModule(_ reactApp: ReactApp) -> UIViewController {
        let view = R.storyboard.hybridContentStoryboard.hybridContentViewController()

        let presenter = HybridContentPresenter()
        let interactor = HybridContentInteractor()

        presenter.reactApp = reactApp

        view?.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor

        interactor.output = presenter

        return view!
    }
}
