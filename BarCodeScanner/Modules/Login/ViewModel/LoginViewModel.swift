//
//  LoginViewModel.swift
//
//  Created Manoj Karki on 5/19/20.
//
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

class LoginViewModel: LoginViewModelProtocol {

    fileprivate var localDataManager = LoginLocalDataManager()
    fileprivate let apiDataManager = LoginAPIDataManager()
    
    fileprivate let validator = TextFieldValidator()

    fileprivate var isLoading = BehaviorRelay<Bool>(value: false)
    
    var isLoadingDriver: Driver<Bool> {
        return isLoading.asDriver()
    }
    
    fileprivate var error = BehaviorRelay<String?>(value: nil)
    
    var errorDriver: Driver<String?> {
        return error.asDriver()
    }

    fileprivate var success = BehaviorRelay<Bool>(value: false)
    
    var successDriver: Driver<Bool> {
        return success.asDriver()
    }

    fileprivate func communicateSuccess() {
        self.isLoading.accept(false)
        self.success.accept(true)
    }
    
    func communicateError(errorMessage: String?) {
        self.isLoading.accept(false)
        self.success.accept(false)
        self.error.accept(errorMessage)
    }

    // Login credentials
    var email = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    
    var isEmailValid: ValidationResult {
        return validator.validate(type: .email, text: self.email.value)
    }
    
    var isPasswordValid: ValidationResult {
        return validator.validate(type: .loginPassword, text: self.password.value)
    }

    var isFormValid: Observable<Bool> {
        
        return Observable.combineLatest(self.email.asObservable(), self.password.asObservable()) { (email: String, pass: String) in
            return !email.isEmpty && !pass.isEmpty
        }
    }
}

extension LoginViewModel {
    
    func login() {

        self.isLoading.accept(true)
        
        let params = [ "email":  self.email.value, "password": self.password.value ]
        apiDataManager.login(params: params, onSuccess: { tokenResult in
            // Save token
            self.manageToken(tokenString: tokenResult)
        }) {
            self.communicateError(errorMessage: $0)
        }
    }

    private func manageToken(tokenString: String?) {
        guard let token = tokenString, !token.isEmpty else {
            self.communicateError(errorMessage: APIErrorMessage.somethingWentWrong)
            return
        }
        self.localDataManager.saveToken(tokenString: token)
        self.communicateSuccess()
    }

}
