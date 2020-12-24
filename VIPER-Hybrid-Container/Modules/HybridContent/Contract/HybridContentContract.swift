//
//  HybridContentContract.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

protocol HybridContentView: IndicatableView {
    var presenter: HybridContentPresentation! { get set }
    
    func loadReactAppODRContentData(_ stringTag: String)
}

protocol HybridContentPresentation: class {
    weak var view: HybridContentView? { get set }
    var interactor: HybridContentUseCase! { get set }

    func viewDidLoad()
}

protocol HybridContentUseCase: class {
    weak var output: HybridContentInteractorOutput! { get set }
    
    func fetchReactAppODR(_ stringTag:String)
}

protocol HybridContentInteractorOutput: class {
    func reactAppODRAvailable(_ stringTag: String)
    func reactAppODRFetchFailed(_ error:String)
}


protocol HybridContentWireframe: class {
    static func assembleModule(_ reactApp:ReactApp) -> UIViewController
}
