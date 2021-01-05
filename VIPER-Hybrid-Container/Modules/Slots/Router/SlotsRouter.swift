//
//  SlotsRouter.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 28/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

class SlotsRouter: SlotsWireframe {

    weak var viewController: UIViewController?

    static func assembleModule() -> UIViewController {
        let view = R.storyboard.slotsStoryboard.slotsViewController()
//        let presenter = IntroPresenter()
        let router = SlotsRouter()

//        view?.presenter = presenter

//        presenter.view = view
//        presenter.router = router

        router.viewController = view

        return view!
    }

}
