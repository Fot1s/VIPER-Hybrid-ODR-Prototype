//
//  RootRouter.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 12/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

class RootRouter: RootWireframe {
    
    func presentReactAppsScreen(in window: UIWindow) {
        window.makeKeyAndVisible()
        window.rootViewController = ReactAppsRouter.assembleModule()
    }
}
