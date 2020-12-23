//
//  RootRouter.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 12/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

class RootRouter: RootWireframe {
    
    func presentIntroScreen(in window: UIWindow) {
        window.makeKeyAndVisible()
        window.rootViewController = IntroRouter.assembleModule()
    }
}
