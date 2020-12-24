//
//  ReactAppsPresenter.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

class ReactAppsPresenter: ReactAppsPresentation {

    weak var view: ReactAppsView?
    var interactor: ReactAppsUseCase!
    var router: ReactAppsWireframe!
    
    var reactApps: [ReactApp] = [] {
        didSet {
            if reactApps.count > 0 {
                view?.showReactAppsData(reactApps)
            }
        }
    }
    
    func viewDidLoad() {
        interactor.fetchReactApps()
        view?.showActivityIndicator()
    }
    
    func didSelectReactApp(_ reactApp: ReactApp) {
        router.presentHybridContent(forReactApp: reactApp)
    }
}

extension ReactAppsPresenter: ReactAppsInteractorOutput {
    
    func reactAppsFetched(_ reactApps: [ReactApp]) {
        self.reactApps = reactApps
        view?.hideActivityIndicator()
    }
    
    internal func reactAppsFetchFailed(_ error:String) {
        view?.showActivityError(error)
    }
}
