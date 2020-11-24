//
//  LoginViewController.swift
//
//  Created Manoj Karki on 5/19/20.
//
//

import UIKit

//MARK:-

class LoginViewController: BaseViewController, StoryboardInitializable {

    //MARK:- IBOutlets
    
    
    @IBOutlet weak var emailFieldContainer: UIView!
    @IBOutlet weak var passwordFieldContainer: UIView!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var singUpBtn: TextButtonUnderlined!
    @IBOutlet weak var loginBtn: StandardInsetButtonWide!
    
    //MARK:- View Model
    var viewModel = LoginViewModel()
    
    //MARK:- Coordinator
    var coordinator: LoginCoordinator?
    
  //  var vcTitle: String = ""
    
    fileprivate let passowrdIcon = "icon_password"
    fileprivate let emailIcon = "icon_line_email"

//    fileprivate let emailIdPlaceholder = "Email Id"
//    fileprivate let passwordPlaceholder = "Password"

    // MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.setupUI()
        self.bindViewModel()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //MARK:- IBActions
    @IBAction func loginBtnClicked(_ sender: Any) {
        
//        self.coordinator?.showScanner()
//        return

        let isEmailValid = self.viewModel.isEmailValid
        let isPasswordValid = self.viewModel.isPasswordValid

        self.view.endEditing(true)
        
        if !isEmailValid.0 {
            self.showAlert(title: "Alert", message: isEmailValid.1)
            return
        }

        if !isPasswordValid.0 {
            self.showAlert(title: "Alert", message: isPasswordValid.1)
            return
        }

        self.viewModel.login()
    }

    @IBAction func forgotPassClicked(_ sender: Any) {
        //self.coordinator?.gotoForgotPassword()
    }

    @IBAction func singUpClicked(_ sender: Any) {
        //self.coordinator?.gotoSignup()
    }

    //MARK:- UI Setup
    
    private func setupUI() {
        
        emailFieldContainer.rounded()
        passwordFieldContainer.rounded()
        
        emailFieldContainer.set(borderColor: UIColor.init(hex: "#707070").withAlphaComponent(0.2))
        passwordFieldContainer.set(borderColor: UIColor.init(hex: "#707070").withAlphaComponent(0.2))
        
        emailFieldContainer.set(borderWidth: 1.0)
        passwordFieldContainer.set(borderWidth: 1.0)
    
        loginBtn.setBackgroundImage(UIImage.fromColor(color: IMColor.redThemeColor.value), for: .normal)
        loginBtn.setBackgroundImage(UIImage.fromColor(color: IMColor.redThemeColor.value.withAlphaComponent(0.35)), for: .disabled)
        
        loginBtn.backgroundColor = .clear

        self.singUpBtn.setUnderlinedTitle(titleTxt: "Signup")
        
        self.emailField.delegate = self
        self.passwordField.delegate = self
    }

    private func clearLoginForm() {
        self.emailField.text = ""
        self.passwordField.text = ""
    }

}

//MARK:- Bind View Model

extension LoginViewController {
    
    func bindViewModel() {
        
      //   Rx binding viewModel -> controller
        (self.emailField.rx.text.orEmpty <-> self.viewModel.email).disposed(by: self.disposeBag)
        (self.passwordField.rx.text.orEmpty <-> self.viewModel.password).disposed(by: self.disposeBag)
        
//        self.viewModel.isFormValid.bind(to: self.loginBtn.rx.isEnabled).disposed(by: self.disposeBag)
    
        self.viewModel.isLoadingDriver.drive(onNext: { [weak self] isLoading in
            self?.showHud(show: isLoading)
        }).disposed(by: self.disposeBag)
        
        self.viewModel.successDriver.filter { return $0 == true }.drive(onNext: { [weak self] _ in
            self?.showSuccessAlert(message: "Login success!")
            //self?.coordinator?.gotoProfile()

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
