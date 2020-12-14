//
//  HybridContentPresenter.swift
//  VIPER-Hybrid-Container
//
//  Created by Demitri Delinikolas on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation

class HybridContentPresenter: HybridContentPresentation {

    weak var view: HybridContentView?
    var interactor: HybridContentUseCase!

    var reactApp:ReactApp!

    func viewDidLoad() {
        interactor.fetchReactAppODR(reactApp.localPath)
        view?.showActivityIndicator()
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
