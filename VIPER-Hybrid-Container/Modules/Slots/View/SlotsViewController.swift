//
//  SlotsViewController.swift
//  VIPER-Hybrid-Container
//
//  Created by Demitri Delinikolas on 28/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit
import SpriteKit

class SlotsViewController: UIViewController {
    
    
    @IBOutlet weak var sceneKitView: SKView!
    
    override func viewDidLoad() {
        
//        if let scene = SKScene(fileNamed: "SlotsScene") {
        let scene = SlotsGameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .aspectFit
        sceneKitView.showsFPS = true
        sceneKitView.showsNodeCount = true
        sceneKitView.showsDrawCount = true
        sceneKitView.ignoresSiblingOrder = true
        sceneKitView.presentScene(scene)
        }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        sceneKitView.scene?.size = size
//        sceneKitView.scene?.anchorPoint.y 
//    }
}
