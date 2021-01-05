//
//  AppDelegate.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 12/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {

    var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        RootRouter().presentIntroScreen(in: window!)
        return true
    }
}
