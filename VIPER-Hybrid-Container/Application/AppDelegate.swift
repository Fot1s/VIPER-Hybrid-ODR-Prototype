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

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        // The persistent container for the application. This implementation
        // creates and returns a container, having loaded the store for the
        // application to it. This property is optional since there are legitimate
        // error conditions that could cause the creation of the store to fail.
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (_, error) in //storeDescription
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                /// You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        RootRouter().presentIntroScreen(in: window!)
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {

        if let rotatableView = topViewController(for: self.window?.rootViewController) as? RotatableView {
            return rotatableView.allowedOrientations()
        } else {
            return UIInterfaceOrientationMask.all
        }
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
