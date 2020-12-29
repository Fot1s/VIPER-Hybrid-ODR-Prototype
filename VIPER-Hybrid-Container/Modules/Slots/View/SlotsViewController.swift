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
        
        if let scene = SKScene(fileNamed: "SlotsScene") {
            scene.scaleMode = .aspectFill
            sceneKitView.showsFPS = true
            sceneKitView.showsNodeCount = true
            sceneKitView.showsDrawCount = true
            sceneKitView.ignoresSiblingOrder = true
            sceneKitView.presentScene(scene)
        }
    }
}
