//
//  ReactAppsContract.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

protocol ReactAppsView: IndicatableView {
    var presenter: ReactAppsPresentation! { get set }
    
    func showReactAppsData(_ reactApps: [ReactApp])
}

protocol ReactAppsPresentation: class {
    weak var view: ReactAppsView? { get set }
    var interactor: ReactAppsUseCase! { get set }
    var router: ReactAppsWireframe! { get set }
    
    func viewDidLoad()
    func didSelectReactApp(_ reactApp: ReactApp)
}

protocol ReactAppsUseCase: class {
    var apiService: APIService! { get set }

    weak var output: ReactAppsInteractorOutput! { get set }
    
    func fetchReactApps()
}

protocol ReactAppsInteractorOutput: class {
    func reactAppsFetched(_ reactApps: [ReactApp])
    func reactAppsFetchFailed(_ error:String)
}

protocol ReactAppsWireframe: class {
    
    weak var viewController: UIViewController? { get set }
    
    func presentHybridContent(forReactApp reactApp: ReactApp)
    
    static func assembleModule() -> UIViewController
}
