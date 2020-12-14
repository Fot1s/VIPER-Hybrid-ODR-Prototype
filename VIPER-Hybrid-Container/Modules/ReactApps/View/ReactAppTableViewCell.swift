//
//  ReactAppTableViewCell.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit
import Kingfisher

class ReactAppTableViewCell: UITableViewCell {
    

    @IBOutlet weak var reactAppImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(_ reactApp: ReactApp) {
        titleLabel?.text = reactApp.title
        reactAppImageView.kf.setImage(
            with: URL(string: reactApp.imageUrl),
            placeholder: UIImage(named: Constants.imagePlaceholder),
            options: nil,
            progressBlock: nil,
            completionHandler: nil
        )
    }
}

