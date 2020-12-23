//
//  IntroViewController.swift
//  VIPER-Hybrid-Container
//
//  Created by Demitri Delinikolas on 23/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBAction func showWebAndODRContentAction(_ sender: Any) {
        presenter.didSelectWebAndODRContent()
    }
    
    
    @IBAction func showSportsBookAction(_ sender: Any) {
        presenter.didSelectPlayBook()
    }
    
    var presenter: IntroPresentation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension IntroViewController: IntroView {
    
}
