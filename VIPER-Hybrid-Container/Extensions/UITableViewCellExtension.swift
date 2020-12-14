//
//  UITableViewCellExtension.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

extension UITableViewCell: ReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: NibLoadableView {
    
    static var NibName: String {
        return String(describing: self)
    }
}
