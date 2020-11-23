//
//  LoginViewController.swift
//  IME Motors
//
//  Created Manoj Karki on 5/19/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//
//

import UIKit
import MaterialComponents
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

//MARK:-

class LoginViewController: BaseViewController, StoryboardInitializable {

    //MARK:- IBOutlets
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var emailField: MDCFilledTextField!
    @IBOutlet weak var passwordField: MDCFilledTextField!
    @IBOutlet weak var singUpBtn: TextButtonUnderlined!
    @IBOutlet weak var loginWithLabel: UILabel!
    @IBOutlet weak var loginBtn: StandardInsetButtonWide!
    
    //MARK:- View Model
    var viewModel = LoginViewModel()
    
    //MARK:- Coordinator
    var coordinator: LoginCoordinator?
    
    var vcTitle: String = ""
    
    fileprivate let passowrdIcon = "icon_password"
    fileprivate let emailIcon = "icon_line_email"

    fileprivate let emailIdPlaceholder = "Email Id"
    fileprivate let passwordPlaceholder = "Password"
    fileprivate let settingIcon = "icon_setting"
    
    fileprivate var facebookLoginHelper: FacebookLoginHelper?

    // MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.bindViewModel()
        self.setupUI()
        self.setupSocialLogin()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //MARK:- IBActions
    @IBAction func loginBtnClicked(_ sender: Any) {
//        let isEmailValid = self.viewModel.isEmailValid
//        self.emailField.setValidation(info: isEmailValid)
//
//        if !isEmailValid.0 {
//            return
//        }
        self.viewModel.login()
    }

    @IBAction func forgotPassClicked(_ sender: Any) {
        self.coordinator?.gotoForgotPassword()
    }

    @IBAction func loginWithCustomerCode(_ sender: Any) {
        self.clearLoginForm()
        self.coordinator?.showVerifyCustomerCodePopUp { [weak self] in
            self?.viewModel.verifyAndLoginWithCustomerCode(customerInfo: $0)
        }
    }

    @IBAction func singUpClicked(_ sender: Any) {
        self.coordinator?.gotoSignup()
    }

    @IBAction func loginWithFacebook(_ sender: Any) {
        self.clearLoginForm()
        self.facebookLoginHelper?.login()
    }

    @IBAction func signInWithGoogle(_ sender: Any) {
        self.clearLoginForm()
        self.viewModel.signInWithGoogle()
    }

    //MARK:- UI Setup
    
    private func setupUI() {
        self.fbButton.rounded()
        self.googleButton.rounded()
        
        loginBtn.setBackgroundImage(UIImage.fromColor(color: IMColor.redThemeColor.value), for: .normal)
        loginBtn.setBackgroundImage(UIImage.fromColor(color: IMColor.redThemeColor.value.withAlphaComponent(0.35)), for: .disabled)
        
        loginBtn.backgroundColor = .clear

        self.singUpBtn.setUnderlinedTitle(titleTxt: "Signup")
        
        self.emailField.setup(label: emailIdPlaceholder, leadingIcon: emailIcon)
        self.passwordField.setup(label: passwordPlaceholder, leadingIcon: passowrdIcon)
        self.passwordField.setPasswordShowHideToggle()

        self.addRightBarButton(imageName: settingIcon, tintColor: .white, sel: #selector(self.settingTapped))
        
        self.emailField.delegate = self
        self.passwordField.delegate = self
    }

    @objc private func settingTapped() {
        self.coordinator?.gotoSettings()
    }

    private func setupSocialLogin() {
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        self.facebookLoginHelper = FacebookLoginHelper.init(fromVc: self)
        
        self.facebookLoginHelper?.onLogin = { [weak self] in
            self?.viewModel.manageFacebookProfile(userDetails: $0)
        }
        self.facebookLoginHelper?.onError = { [weak self] in
            self?.viewModel.communicateError(errorMessage: $0)
        }
    }

    private func clearLoginForm() {
        self.emailField.text = ""
        self.passwordField.text = ""
    }

}

//MARK:- Bind View Model

extension LoginViewController {
    
    func bindViewModel() {
        
        // Rx binding viewModel -> controller
        (self.emailField.rx.text.orEmpty <-> self.viewModel.email).disposed(by: self.disposeBag)
        (self.passwordField.rx.text.orEmpty <-> self.viewModel.password).disposed(by: self.disposeBag)
        
        self.viewModel.isFormValid.bind(to: self.loginBtn.rx.isEnabled).disposed(by: self.disposeBag)
    
        self.viewModel.isLoadingDriver.drive(onNext: { [weak self] isLoading in
            self?.showHud(show: isLoading)
        }).disposed(by: self.disposeBag)
        
        self.viewModel.successDriver.filter { return $0 == true }.drive(onNext: { [weak self] _ in
            //self?.showSuccessAlert(message: "Login success!")
            self?.coordinator?.gotoProfile()

        }).disposed(by: self.disposeBag)
        
        self.viewModel.errorDriver.filter { return $0 != nil }.drive(onNext: { [weak self] errorMessage in
            self?.showErrorAlert(message: errorMessage)
        }).disposed(by: self.disposeBag)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        }else if self.loginBtn.isEnabled  {
            self.loginBtnClicked(UIButton())
        }
        return true
    }

}
