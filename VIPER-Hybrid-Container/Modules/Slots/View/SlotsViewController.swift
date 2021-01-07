//
//  SlotsViewController.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 28/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit
import SpriteKit

class SlotsViewController: UIViewController {

    @IBOutlet weak var sceneKitView: SKView!

    override func viewDidLoad() {

//        if let scene = SKScene(fileNamed: "SlotsScene") {
//        let scene = SlotsGameScene(size: UIScreen.main.bounds.size)

        let navBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (navigationController?.navigationBar.frame.height ?? 0.0)

        var visibleArea = UIScreen.main.bounds.size
        visibleArea.height -= navBarHeight

        let scene = SlotsGameAndScene(size: visibleArea)
        scene.scaleMode = .aspectFit
//        sceneKitView.showsFPS = true
//        sceneKitView.showsNodeCount = true
//        sceneKitView.showsDrawCount = true
        sceneKitView.ignoresSiblingOrder = true
        sceneKitView.presentScene(scene)
        }

//    override var prefersStatusBarHidden: Bool {
//        return true
//    }

//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = true
//    }
}
