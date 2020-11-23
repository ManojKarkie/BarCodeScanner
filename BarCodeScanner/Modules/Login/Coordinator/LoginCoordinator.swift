//
//  LoginCoordinator.swift
//  IME Motors
//
//  Created Manoj Karki on 5/19/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//
//

import UIKit

class LoginNav: UINavigationController {

    override var childForStatusBarStyle: UIViewController? {
        self.topViewController
    }
}

class LoginCoordinator: NSObject, Coordinator, LoginCoordinatorProtocol {

    var childCoordinators: [Coordinator] = []

    private(set) var navigationController: UINavigationController

    var onLoggedIn: VoidClosure = nil
    
    init(nav: UINavigationController = LoginNav()) {

        self.navigationController = nav
        self.navigationController.view.backgroundColor = .white
        
        self.navigationController.navigationBar.backgroundColor = .clear
        self.navigationController.navigationBar.isTranslucent = true
        self.navigationController.navigationBar.barTintColor = .clear
        self.navigationController.navigationBar.shadowImage = UIImage()
        self.navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
       // self.navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: IMFont.init(.medium, size: .custom(16.0)).instance, NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func start() {
        let loginVc = LoginViewController.initWith(storyboard: Storyboards.Login.login)
//        let profileItem = UITabBarItem.init(title: tabTitle, image: UIImage(named: grayImage), tag: 2)
//        profileItem.selectedImage =  UIImage(named: redImage)
//        loginVc.tabBarItem = profileItem
        loginVc.coordinator = self

        self.navigationController.delegate = self
        self.navigationController.setViewControllers([loginVc], animated: true)
        
        
    }

}

extension LoginCoordinator {
    
   
    
    func gotoProfile() {
        self.onLoggedIn?()
    }
    
    func gotoForgotPassword() {
//        let forgotPassCoordinator = ForgotPasswordCoordinator.init(nav: self.navigationController)
//        forgotPassCoordinator.start()
//        self.addChild(coordinator: forgotPassCoordinator)
    }
    
   
    
    func gotoSignup() {
//        let signupCoordinator = SignupCoordinator.init(nav: self.navigationController)
//        signupCoordinator.parentCoordinator = self
//        signupCoordinator.start()
//        addChild(coordinator: signupCoordinator)
    }
}

extension LoginCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        guard let fromVc = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(fromVc) else {
            return
        }
        
        self.childCoordinators.removeAll()
    }
    
}

