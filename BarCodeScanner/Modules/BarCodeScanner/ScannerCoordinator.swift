//
//  ScannerCoordinator.swift
//  BarCodeScanner
//
//  Created by Manoj Karki on 11/24/20.
//

import UIKit

//class LoginNav: UINavigationController {
//
//    override var childForStatusBarStyle: UIViewController? {
//        self.topViewController
//    }
//}

protocol ScannerCoordinatorProtocol {
    
    func showResponseInfoScreen()
    func dissmissResponseInfoScreen()
}

class ScannerCoordinator: NSObject, Coordinator, ScannerCoordinatorProtocol {

    var childCoordinators: [Coordinator] = []

    private(set) var navigationController: UINavigationController
    
    weak var responseNavVc: UINavigationController?
    weak var scannerVc: BarCodeScannerViewController?

    var window: UIWindow?

    init(nav: UINavigationController = LoginNav(), window: UIWindow?) {

        self.window = window
        
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
        let scannerVc =  BarCodeScannerViewController.initWith(storyboard: Storyboards.barCodeScan)
//        let profileItem = UITabBarItem.init(title: tabTitle, image: UIImage(named: grayImage), tag: 2)
//        profileItem.selectedImage =  UIImage(named: redImage)
//        loginVc.tabBarItem = profileItem
      //  loginVc.coordinator = self

       // self.navigationController.delegate = self
        //self.navigationController.setViewControllers([loginVc], animated: true)
        
        scannerVc.coordinator = self
        
        self.scannerVc  = scannerVc
        self.window?.rootViewController = scannerVc
    }

}

extension ScannerCoordinator {
    
    func showResponseInfoScreen() {
        let responseVc  =  ResponseInfoViewController.initWith(storyboard: Storyboards.responseInfo)
        responseVc.coordinator  = self
        let responseNav = UINavigationController()
        responseNav.setViewControllers([responseVc], animated: true)
        
        self.window?.rootViewController?.present(responseNav, animated: true)
        self.responseNavVc = responseNav
    }
    
    func dissmissResponseInfoScreen() {
        
        self.responseNavVc?.dissmiss()
        
        self.scannerVc?.reStart()
    }

}

extension ScannerCoordinator: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        guard let fromVc = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(fromVc) else {
            return
        }
        
        self.childCoordinators.removeAll()
    }
    
}
