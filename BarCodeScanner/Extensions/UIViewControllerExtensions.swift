//
//  UIViewControllerExtensions.swift
//  IME Motors
//
//  Created by Manoj Karki on 4/26/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import SVProgressHUD
import KRProgressHUD
import RxSwift
import RxCocoa


struct Associate {

    static var hud: UInt8 = 0
    static var refreshControl: UInt8 = 1
}


extension UIApplication {

    @available(iOS 13.0, *)
    class var keyWindow: UIWindow? {
    
        get {
            
            return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first

        }
        
    }
    
}

protocol StoryboardInitializable: class {}

extension StoryboardInitializable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }

    static func initWith(storyboard sb: String?) -> Self {
        let storyboard =  UIStoryboard.init(name: sb ?? "", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier ) as! Self
    }

}



extension UIViewController {

    func addNavSeparator() {
        if let _ = navigationController {
           let separator = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: 1.0))
            separator.tag = 977
            separator.backgroundColor = IMColor.navSeparatorColor.value
           view.addSubview(separator)
           view.bringSubviewToFront(separator)
        }
    }
    
    func removeNavSeparator() {
        self.view.subviews.forEach {
            if $0.tag == 977 {
                $0.removeFromSuperview()
            }
        }
    }

    class func topViewController() -> UIViewController {
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        var rootViewController = delegate.window!.rootViewController
        
//        while rootViewController?.presentedViewController != nil {
//            rootViewController = rootViewController?.presentedViewController
//        }
//        return rootViewController!
        
        return UIViewController()
    }

    func addRightBarButton(imageName: String, tintColor: UIColor = UIColor.black, sel: Selector) {
        let rightBarButton = UIBarButtonItem(image: UIImage(named:imageName), style: .plain, target: self, action:sel)
        rightBarButton.tintColor = tintColor
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func addRedRightBarButton(title: String, sel: Selector) {
        let rightBarButton = UIBarButtonItem.init(title: title, style: .plain, target: self, action: sel)
        rightBarButton.tintColor = IMColor.redThemeColor.value
        let font = IMFont.init(.medium, size: .custom(14.0)).instance
        rightBarButton.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        rightBarButton.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .selected)
        navigationItem.rightBarButtonItem = rightBarButton
    }

    func addRightBarBtn(sel: Selector) {
        let cancelBtn = UIBarButtonItem(image: UIImage(named:"close_small"), style: .plain, target: self, action:sel)
        cancelBtn.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = cancelBtn
    }
    
    
    
    func addCancelBtn() {
        let cancelBtn = UIBarButtonItem(image: UIImage(named:"close_small"), style: .plain, target: self, action:#selector(self.dissmiss))
        navigationItem.rightBarButtonItem = cancelBtn
    }
    
    func addLeftCancelBtn() {
        let cancelBtn = UIBarButtonItem(image: UIImage(named:"close_small"), style: .plain, target: self, action:#selector(self.dissmiss))
        navigationItem.leftBarButtonItem = cancelBtn
    }

    func addCancelBtn(sel: Selector) {
        let cancelBtn = UIBarButtonItem(image: UIImage(named:"close_small"), style: .plain, target: self, action:sel)
        cancelBtn.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = cancelBtn
    }
    
    func addCancelBtnLeft(sel: Selector) {
        let cancelBtn = UIBarButtonItem(image: UIImage(named:"close_small"), style: .plain, target: self, action:sel)
        cancelBtn.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = cancelBtn
    }

    @objc func dissmiss() {
        self.dismiss(animated: true, completion: nil)
    }

    func addWhiteNavCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image:#imageLiteral(resourceName: "back") , style: UIBarButtonItem.Style.plain, target: self, action: #selector(whiteNavButtonClicked))
    }

    @objc func whiteNavButtonClicked() {
        let barButtonApperance = UIBarButtonItem.appearance()
        barButtonApperance.tintColor = UIColor.black
       // UINavigationBar.addShowdowLine()
        dissmiss()
    }

    func addTwoToneInfoBtn(sel: Selector) {
        let cancelBtn = UIBarButtonItem(image: UIImage(named:"referral-info"), style: .plain, target: self, action:sel)
        navigationItem.rightBarButtonItem = cancelBtn
    }

}

extension UIViewController {
    
    // UIAlertController & Rx

    func showAlertMessage(title: String?, message: String? = nil, closeTitle: String? = "Ok") -> Observable<Void> {
    
        return Observable<Void>.create { [weak self] (observer) -> Disposable in
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: closeTitle, style: .default) {  _ in
                observer.onCompleted()
            }
            alert.addAction(action)
            self?.present(alert, animated: true, completion: nil)
            
            return Disposables.create {
               // print("Alert is about to be dismissed")
                if let _ = self?.presentedViewController {
                   self?.dismiss(animated: true, completion: nil)
                }
            }
        }

    }

    func showAlert(title: String?, message: String? = "", actionTitle: String? = "Ok") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(message: String? = "", actionTitle: String? = "Ok", onCompletion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(action)

        present(alert, animated: true) {
            onCompletion?()
        }

    }

    func showSuccessAlert(message: String? = "") {
        
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func showErrorAlertWithAction(_ message: String?, actionTitle: String? = "Ok", completionAction: @escaping (UIAlertAction) -> ()) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: completionAction)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func showAlertWithCompletion(title: String?, message: String? = "", actionTitle: String? = "Ok", completion: @escaping (UIAlertAction) -> ()){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: completion)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func showAlertWithOk(title: String?, message: String? = "", action1Title: String? = "Ok",  action2Title: String? = "Cancel", completion: @escaping (UIAlertAction) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: action1Title, style: .default, handler: completion)
        let action2 = UIAlertAction(title: action2Title, style: .default)
        
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithOkCancel(title: String?, message: String? = "", action1Title: String? = "Ok",  action2Title: String? = "Cancel", okAction: @escaping (UIAlertAction) -> (), cancelAction: @escaping (UIAlertAction) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: action1Title, style: .default, handler: okAction)
        let action2 = UIAlertAction(title: action2Title, style: .default, handler: cancelAction)
        alert.addAction(action2)
        alert.addAction(action1)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithOkCancelDestructive(title: String?, message: String? = "", action1Title: String? = "Ok",  action2Title: String? = "Cancel", okAction: @escaping (UIAlertAction) -> (), cancelAction: @escaping (UIAlertAction) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: action1Title, style: .destructive, handler: okAction)
        let action2 = UIAlertAction(title: action2Title, style: .default, handler: cancelAction)
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
    
//    func showErrorViewController(with error: Error) {
//        let vc = RemitNoInfoViewController.initFromStoryboard(name: "RemitNoInfo")
//        vc.errorString = error.localizedDescription
//        self.present(vc, animated: true, completion: nil)
//    }
}

//MARK:- Progress Hud Helpers

extension UIViewController {

    private func setProgressHud() -> MBProgressHUD {
        let progressHud:  MBProgressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
      //  progressHud.backgroundView.style = MBProgressHUDBackgroundStyle.blur
        progressHud.animationType = .zoom
        progressHud.tintColor = UIColor.darkGray
        progressHud.removeFromSuperViewOnHide = true
        objc_setAssociatedObject(self, &Associate.hud, progressHud, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return progressHud
    }

    var progressHud: MBProgressHUD {

        if let progressHud = objc_getAssociatedObject(self, &Associate.hud) as? MBProgressHUD {
            progressHud.isUserInteractionEnabled = true
            return progressHud
        }
        return setProgressHud()
    }

    var progressHudIsShowing: Bool {
        return self.progressHud.isHidden
    }

    func showHud(show: Bool, message: String? = "Loading..") {

        if show {
            self.progressHud.label.text =  message
            self.progressHud.show(animated: true)
            
        }else {
            DispatchQueue.main.async {
               self.hideProgressHud()
            }
        }
    }

    func hideProgressHud() {
        self.progressHud.label.text = ""
        self.progressHud.completionBlock = {
            objc_setAssociatedObject(self, &Associate.hud, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        self.progressHud.hide(animated: true)
    }
    
    

    // SVProgressHUD Code

//    func showHud(_decision: Bool, desc: String? = nil) {
//
//        var containerView = view
//
//        if let nav = self.navigationController {
//            containerView = nav.view
//        }
//
//        if _decision  == true {
//            SVProgressHUD.setForegroundColor(IMPColor.darkText.value)
//            SVProgressHUD.setBackgroundColor(IMPColor.intermidiateBackground.value)
//            SVProgressHUD.setFont(IMPFont.init(.installed(.sfRegular), size: .custom(14.0)).instance)
//            SVProgressHUD.setContainerView(containerView)
//            SVProgressHUD.show(withStatus: desc)
//            return
//        }
//
//        SVProgressHUD.dismiss()
//    }

//    func showHud(inView containerView: UIView, statusText: String) {
//        SVProgressHUD.setContainerView(containerView)
//        SVProgressHUD.show()
//    }
    
//    func dissmissProgressHud() {
//        SVProgressHUD.dismiss()
//    }
//
//    func dissmissHud(inVIew containerView: UIView) {
//        DispatchQueue.main.async {
//            SVProgressHUD.dismiss()
//        }
//    }

//    func showHud(show: Bool, message: String? = "Loading..") {
//
//        DispatchQueue.main.async {
//            if show {
//                KRProgressHUD.set(style: .black)
//                // KRProgressHUD.set(maskType: .white)
//                KRProgressHUD.set(activityIndicatorViewColors: [IMColor.redThemeColor.value])
//                KRProgressHUD.show(withMessage: message) {}
//            }else {
//                KRProgressHUD.dismiss {}
//            }
//        }
//    }

    func showHudInVc(show: Bool, message: String? = "Loading..") {

        DispatchQueue.main.async {
            if show {
                KRProgressHUD.set(style: .black)
                // KRProgressHUD.set(maskType: .white)
                KRProgressHUD.set(activityIndicatorViewColors: [IMColor.redThemeColor.value])
                let _ = KRProgressHUD.showOn(self)
            }else {
                KRProgressHUD.dismiss {}
            }
        }
    }
    
    func showMessageView(type: MessageViewType? = .error, message: String?) {
        
        let messageView = MessageView.init()
        messageView.present(type: type, message: message)

    }

}

// Error Message toast View helpers

extension UIViewController {

//    func showErrorMessage(message: String?) {
//
//        RMessage.showNotification(in: self, title: "Error!", subtitle: message ?? "", type: .error, customTypeName: "", duration: 1, callback: {
//
//        }, canBeDismissedByUser: true)
//    }
    
//    func showWarningMessage(message: String?) {
//
//        RMessage.showNotification(in: self, title: "", subtitle: message ?? "", type: .warning, customTypeName: "", duration: 1, callback: {
//
//        }, canBeDismissedByUser: true)
//
//
//    }

}

// MARK:- Viewcontorller containment

extension UIViewController {
    
    func addChildVc(_ child: UIViewController, containerView: UIView) {
        addChild(child)
        child.view.frame = containerView.bounds
        child.view.frame.size.width = containerView.frame.width
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
}

extension UINavigationController {
    
    func setWhiteNavBar() {

        self.view.backgroundColor = .white
        
        self.navigationBar.backgroundColor = .white
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = .white
        self.navigationBar.shadowImage = UIImage.separatorFromColor(color: IMColor.navSeparatorColor.value)
        self.navigationBar.setBackgroundImage(UIImage.fromColor(color: .white), for: UIBarMetrics.default)
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: IMFont.init(.medium, size: .custom(16.0)).instance, NSAttributedString.Key.foregroundColor: IMColor.titleColorDark.value]

        self.navigationBar.setValue(false, forKey: "hidesShadow")
        
    }

    func setRedNavBar() {
        
        self.view.backgroundColor = .white
        
        self.navigationBar.backgroundColor = IMColor.redThemeColor.value
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = IMColor.redThemeColor.value
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: IMFont.init(.medium, size: .custom(16.0)).instance, NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
}



