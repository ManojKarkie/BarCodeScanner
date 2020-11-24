//
//  AppCoordinator.swift
//
//  Created by Manoj Karki on 4/26/20.
//

import Foundation
import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {

    func removeChild(coordinator: Coordinator) {
        self.childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }

    func addChild(coordinator: Coordinator) {
        self.childCoordinators.append(coordinator)
    }

}

protocol NavigationCoordinator {
    
    var navigationController: UINavigationController? { get set }

    init(nav: UINavigationController?)
    
}

typealias NavCoordinator = Coordinator & NavigationCoordinator

protocol AppCoordinatorProtocol {
    
    func gotoLogin()
    func showScanner()
    
}

class AppCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {

      // print("BACKEDN URL ==== \(ServerUrl.baseUrl)")
        if UserSessionManager.isUserLoggedIn {
           // self.gotoLogin()
            
            self.showScanner()
        }else {
            self.gotoLogin()
        }

    }

}

extension AppCoordinator: AppCoordinatorProtocol {

    func gotoLogin() {
        
        let loginCoordinator = LoginCoordinator.init(nav: UINavigationController(), window: self.window)
        
        loginCoordinator.onLoggedIn = {
            self.showScanner()
            self.removeChild(coordinator: loginCoordinator)
        }
    
        loginCoordinator.start()
        self.childCoordinators.append(loginCoordinator)
        
    }
    
    func showScanner() {
       
        let scannerCoordinator = ScannerCoordinator.init(nav: UINavigationController(), window: self.window)
        scannerCoordinator.start()
        
        self.addChild(coordinator: scannerCoordinator)
        
        
    }

//    func gotoHome() {
//
//        guard let _ = self.window else { return }
//
//        UIView.transition(with: self.window!, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
//            let oldState: Bool = UIView.areAnimationsEnabled
//            UIView.setAnimationsEnabled(false)
//          //  self.window?.rootViewController = RootTabBarController()
//            self.window?.makeKeyAndVisible()
//            UIView.setAnimationsEnabled(oldState)
//        }, completion: { (finished: Bool) -> () in
//
//        })
//
//    }

}
