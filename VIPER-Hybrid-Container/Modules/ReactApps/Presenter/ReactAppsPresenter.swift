//
//  ReactAppsPresenter.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//
import Starscream

class ReactAppsPresenter: ReactAppsPresentation {

    weak var view: ReactAppsView?
    var interactor: ReactAppsUseCase!
    var router: ReactAppsWireframe!
    
    var socketService: WebSocketTestService!
    
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
        
        //TODO: MOVE THE BELLOW IN A NEW VIPER MODULE,
        //POSSIBLY CREATING A WEBSOCLET MANAGER SINGLETON
        //THAT IS INJECTED IN THE MODULE ON CREATION
        //START WEB SOCKET TESTS
        socketService = WebSocketTestService.shared
        socketService.connect(withDelegate: self)
        
        //END WEB SOCKET TESTS
    }
    
    func didSelectReactApp(_ reactApp: ReactApp) {
        router.presentHybridContent(forReactApp: reactApp)
    }
}

extension ReactAppsPresenter: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("Did connect: \(socket)")
        socket.write(string:"Test message") {
            print("Message sent after connect!")
        }
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("Did disconnect: \(error?.localizedDescription ?? "Missing error!")")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Message: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Data: \(data)")
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
