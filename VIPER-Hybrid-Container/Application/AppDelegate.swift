//
//  AppDelegate.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 12/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder {

    var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        RootRouter().presentIntroScreen(in: window!)
        
        //TODO: FIX:
        //Should not be here but in terminate in a real app
        CoreDataService.shared.delete(Match.self)
        
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {

        if let rotatableView = topViewController(for: self.window?.rootViewController) as? RotatableView {
            return rotatableView.allowedOrientations()
        } else {
            return UIInterfaceOrientationMask.all
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        //Does not work in emulator, delete on start for now
        //TODO: //FIX:
        //CoreDataService.shared.delete(Match.self)
    }

    func topViewController(for rootViewController: UIViewController?) -> UIViewController? {
        guard let rootVC = rootViewController else { return nil }

        if let tabBarController = rootVC as? UITabBarController {
            return topViewController(for: tabBarController.selectedViewController)
        } else if let navController = rootVC as? UINavigationController {
            return topViewController(for: navController.visibleViewController)
        } else if let rootPresentedVC = rootVC.presentedViewController {
            return topViewController(for: rootPresentedVC)
        }

        return rootViewController
    }
}
