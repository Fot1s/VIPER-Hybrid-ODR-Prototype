//
//  IntroViewController.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 23/12/2020.
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
        setupView()
    }
    
    fileprivate func setupView() {
        navigationItem.title = Localization.Intro.navigationBarTitle
    }
}

extension IntroViewController: IntroView {
    
}
