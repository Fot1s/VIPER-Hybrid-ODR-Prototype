//
//  HybridContentPresenter.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation

class HybridContentPresenter: HybridContentPresentation {

    weak var view: HybridContentView?
    var interactor: HybridContentUseCase!

    var reactApp: ReactApp?

    func viewDidLoad() {
        if let reactApp = reactApp {
            interactor.fetchReactAppODR(reactApp.localPath)
            view?.showActivityIndicator()
        } else {
            view?.showActivityError("reactApp is not set!")
        }
    }
}

extension HybridContentPresenter: HybridContentInteractorOutput {
    func reactAppODRAvailable(_ stringTag: String) {
        view?.loadReactAppODRContentData(stringTag)
    }

    func reactAppODRFetchFailed(_ error: String) {
        view?.showActivityError(error)
    }
}
