//
//  IndicatableViewExtension.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation
import PKHUD

extension IndicatableView where Self: UIViewController {
    func showActivityError(_ error: String) {
        HUD.flash(.error, delay: 1.0) { _ in //finished in
            HUD.flash(.label(error), delay: 1.0)
        }
    }

    func showActivityIndicator() {
        HUD.show(.progress)
    }

    func hideActivityIndicator() {
        HUD.flash(.success, delay: 0.5)
    }
}
