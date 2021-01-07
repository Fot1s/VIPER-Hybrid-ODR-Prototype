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

    var savedOrientation: UIDeviceOrientation = UIDeviceOrientation.unknown

    override func viewWillAppear(_ animated: Bool) {
        savedOrientation = UIDevice.current.orientation
        //self.navigationController?.isNavigationBarHidden = true
    }

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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        //This is needed because after setting the orientation in viewWillAppear to
        //UIInterfaceOrientationMask.portrait.rawValue, forKey: "orientation")
        //while the phone is in landscape, bellow the value of UIDevice.current.orientation
        //is reported as portraitUpsideDown instead of landScapeLeft/Right
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
            UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {

            UIDevice.current.setValue(UIDevice.current.orientation.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        } else {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }

}

extension SlotsViewController: SlotsView {
    func allowedOrientations() -> UIInterfaceOrientationMask {
        switch savedOrientation {
        case UIDeviceOrientation.landscapeLeft:
            return UIInterfaceOrientationMask.landscapeLeft
        case UIDeviceOrientation.landscapeRight:
            return UIInterfaceOrientationMask.landscapeRight
        default :
            return UIInterfaceOrientationMask.portrait
        }

    }
}
