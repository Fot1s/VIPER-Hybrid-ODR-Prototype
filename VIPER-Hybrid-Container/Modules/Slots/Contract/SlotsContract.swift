//
//  SlotsContract.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 28/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

protocol SlotsView: RotatableView {
//    var presenter: IntroPresentation! { get set }
}

//protocol IntroPresentation: class {
//    weak var view: IntroView? { get set }
//    var router: IntroWireframe! { get set }
//
//    func didSelectWebAndODRContent()
//    func didSelectPlayBook()
//    func didSelectSlots()
//}

protocol SlotsWireframe: class {

    weak var viewController: UIViewController? { get set }

    static func assembleModule() -> UIViewController
}
