//
//  IntroViewController.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 23/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var middleImage: UIImageView!
    @IBOutlet weak var bottomImage: UIImageView!

    @IBAction func showWebAndODRContentAction(_ sender: Any) {
        presenter.didSelectWebAndODRContent()
    }

    @IBAction func showSportsBookAction(_ sender: Any) {
        presenter.didSelectPlayBook()
    }

    @IBAction func showSlotsAction(_ sender: Any) {
        presenter.didSelectSlots()
    }

    var presenter: IntroPresentation!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        changeViewDirectionAndImageContentModes()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        changeViewDirectionAndImageContentModes()
    }

    fileprivate func setupView() {
        navigationItem.title = Localization.Intro.navigationBarTitle
    }

    //change stackview direction and image content modes depending on orientation
    func changeViewDirectionAndImageContentModes() {
        if UIDevice.current.orientation.isPortrait {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }
}

extension IntroViewController: IntroView {

}
