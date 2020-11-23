//
//  AppCoordinator.swift
//  IME Motors
//
//  Created by Manoj Karki on 4/26/20.
//  Copyright © 2020 IME Motors. All rights reserved.
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

class AppCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {

       print("BACKEDN URL ==== \(ServerUrl.baseUrl)")
        if !UserDefaultManager.isOnboardingShown {
//            let onboardCoordinator = OnboardCoordinator.init(win: self.window, parentCo: self)
//            onboardCoordinator.start()
//            self.addChild(coordinator: onboardCoordinator)
        }else {
           // self.gotoSplash()
        }

    }

}

extension AppCoordinator {

    func gotoSplash() {
//        let splashCoordinator = SplashCoordinator.init(win: self.window, parentCo: self)
//        splashCoordinator.start()
//        self.addChild(coordinator: splashCoordinator)
    }

    func gotoHome() {
        
        guard let _ = self.window else { return }

        UIView.transition(with: self.window!, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            let oldState: Bool = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
          //  self.window?.rootViewController = RootTabBarController()
            self.window?.makeKeyAndVisible()
            UIView.setAnimationsEnabled(oldState)
        }, completion: { (finished: Bool) -> () in
           
        })
        
    }

}
