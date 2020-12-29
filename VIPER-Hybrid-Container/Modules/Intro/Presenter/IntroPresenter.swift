//
//  ReactAppsPresenter.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

class IntroPresenter: IntroPresentation {

    weak var view: IntroView?
    var router: IntroWireframe!
    
    func didSelectWebAndODRContent() {
        router.presentReactApps()
    }

    func didSelectPlayBook() {
        router.presentSportsBook()
    }
    
    func didSelectSlots() {
        router.presentSlots()
    }
}

