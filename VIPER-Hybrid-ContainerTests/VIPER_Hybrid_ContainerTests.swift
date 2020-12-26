////
////  VIPER_Hybrid_ContainerTests.swift
////  VIPER-Hybrid-ContainerTests
////
////  Created by Demitri Delinikolas on 25/12/2020.
////  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
////
//
//import XCTest
//import Alamofire
//import AlamofireObjectMapper
//import ObjectMapper
//
//
//@testable import VIPER_Hybrid_Container
//
//class APIService2: APIService {
//    
//    //Generic version of fetch no need to have multiple versions as bellow
//    override func fetch<T>(endPointURL: String, completion: @escaping ([T]?) -> Void) where T: Mappable {
//        completion(nil)
//    }
//}
//
//class APIService3: Network {
//    
//    static let shared = APIService3()
//
//    private init() {
//        
//    }
//    
//    //Generic version of fetch no need to have multiple versions as bellow
//    func fetch<T>(endPointURL: String, completion: @escaping ([T]?) -> Void) where T:Mappable {
//                
//        let matches:[Match]? = [Match(id:1, home:"home", away:"away", bet_1:100,bet_x:200,bet_2:300)]
//        completion(matches as? [T])
//    }
//}
//
//
//class VIPER_Hybrid_ContainerTests: XCTestCase {
//    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        
//        let module = SportsBookRouter2.assembleModule() as! SportsBookViewControllerStab
//        module.presenter.interactor.fetchMatches()
//        
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//    
//}
//
//class SportsBookViewControllerStab: UIViewController, SportsBookView {
//
//    var presenter: SportsBookPresentation!
//
//    func showSportsBookData(_ matches: [Match]) {
//        print("Matches: \(matches)")
//    }
//    
//    func updateSportsBookData(withMatch match:Match, updatedMatch:MatchUpdate, andIndex index:Int) {
//        print("withMatch: \(match) updatedMatch: \(updatedMatch) andIndex: \(index)" )
//    }
//    
//    func showActivityError(_ error:String) {
//    }
//    
//    func showActivityIndicator() {
//    }
//    
//    func hideActivityIndicator() {
//    }
//    
//}
//
//class SportsBookRouter2: SportsBookWireframe {
//    
//    weak var viewController: UIViewController?
//    
//    static func assembleModule() -> UIViewController {
//        let view = SportsBookViewControllerStab()
//        let presenter = SportsBookPresenter()
//        let interactor = SportsBookInteractor()
//        let router = SportsBookRouter()
//        
//        view.presenter = presenter
//        
//        presenter.view = view
//        presenter.interactor = interactor
//        presenter.router = router
//        
//        interactor.output = presenter
//        interactor.apiService = APIService3.shared
//        interactor.socketService = WebSocketTestService.shared
//        
//        router.viewController = view
//        
//        return view
//    }
//    
//    //    func presentHybridContent(forReactApp reactApp: ReactApp) {
//    //        let hybridContentViewController = HybridContentRouter.assembleModule(reactApp)
//    //        viewController?.navigationController?.pushViewController(hybridContentViewController, animated: true)
//    //    }
//    //
//}
//
//
