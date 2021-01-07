//
//  ViewProtocols.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

protocol ReusableView: class {
    static var reuseIdentifier: String { get }
}

protocol NibLoadableView: class {
    static var NibName: String { get }
}

protocol IndicatableView: class {
    func showActivityError(_ error: String)
    func showActivityIndicator()
    func hideActivityIndicator()
}

protocol RotatableView {
    func allowedOrientations() -> UIInterfaceOrientationMask
}
