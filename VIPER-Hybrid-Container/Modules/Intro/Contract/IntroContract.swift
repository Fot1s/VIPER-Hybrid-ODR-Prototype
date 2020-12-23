//
//  ReactAppsContract.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

protocol IntroView :class {
    var presenter: IntroPresentation! { get set }
}

protocol IntroPresentation: class {
    weak var view: IntroView? { get set }
    var router: IntroWireframe! { get set }
    
    func didSelectWebAndODRContent()
    func didSelectPlayBook()
}

protocol IntroWireframe: class {
    
    weak var viewController: UIViewController? { get set }
    
    func presentReactApps()
    func presentSportsBook()

    static func assembleModule() -> UIViewController
}
