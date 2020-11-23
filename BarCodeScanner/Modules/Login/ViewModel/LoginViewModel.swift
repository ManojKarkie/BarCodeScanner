//
//  LoginViewModel.swift
//  Manoj Karki
//
//  Created Manoj Karki on 5/19/20.
//  Copyright © 2020 Manoj Karki. All rights reserved.
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
            self.manageToken(tokenString: tokenResult?.result)
        }) {
            self.communicateError(errorMessage: $0)
        }
    }

    func signInWithGoogle() {

        self.googleSignInHelper.onError = { [weak self] in
            self?.communicateError(errorMessage: $0)
        }

        self.googleSignInHelper.onSignIn = { [weak self] in
            
            let userProfile = UserProfile()
            userProfile.name = $0.profile.name
            userProfile.email = $0.profile.email

            if $0.profile.hasImage {
                userProfile.profilePhotoUrl =  $0.profile.imageURL(withDimension: 100)?.absoluteString
            }

            let token = $0.authentication.accessToken
            self?.authenticateExternalLogin(token: token, loginType: .google, profileData: userProfile)
        }
        self.googleSignInHelper.signIn()
    }
    
    func authenticateExternalLogin(token: String?, loginType: SocialLoginType, profileData: UserProfile) {
        
        self.isLoading.accept(true)
        
        let params =   [
            "externalAccessToken": token ?? "",
            "provider": loginType.rawValue,
            "email": profileData.email ?? "",
            "fullName": profileData.name ?? "",
            "platform": "iOS",
            "mobileNumber": profileData.contactNumber ?? ""
        ]

        self.apiDataManager.authExternalLogin(params: params, onSuccess: { [weak self] in
            
            if let token = $0?.token, !token.isEmpty {
                profileData.socialLoginType = loginType.rawValue
                self?.localDataManager.managerUserProfile(profile: profileData)
            }
            self?.manageToken(tokenString: $0?.token)
            
        }) {
            self.communicateError(errorMessage: $0)
        }
    }
    
    func manageFacebookProfile(userDetails: Any?) {

        guard let details = userDetails, let _ = JSON(details).dictionaryObject else {
            self.communicateError(errorMessage: APIErrorMessage.somethingWentWrong)
            return
        }
        
        let json = JSON(details)
        
        let email = json["email"].string ?? ""
        let name = json["name"].string ?? ""
        let profilePicUrl = json["picture"]["data"]["url"].string ?? ""
        
        let userProfile = UserProfile()
        userProfile.name = name
        userProfile.email = email
        userProfile.profilePhotoUrl = profilePicUrl
        
        let accessToken = AccessToken.current?.tokenString ?? ""
        self.authenticateExternalLogin(token: accessToken, loginType: .facebook, profileData: userProfile)
    }
    
    func verifyAndLoginWithCustomerCode(customerInfo: VerifyCustomerCodeFormInfo) {

        self.isLoading.accept(true)
        let params = ["customerCode": customerInfo.customerCode, "contactNumber": customerInfo.contactNum]
        
        apiDataManager.verifyCustomerCode(params: params, onSuccess: { navCustomerDetails in
            self.customerCodeLogin(customerInfo: customerInfo, navDetails: navCustomerDetails)
        }) { errorMessage in
            self.communicateError(errorMessage: errorMessage)
        }
    }

    func customerCodeLogin(customerInfo: VerifyCustomerCodeFormInfo, navDetails: NavCustomerDetail?) {
        
        let params = ["customerCode": customerInfo.customerCode]
        apiDataManager.loginWithCustomerCode(params: params, onSuccess: { [unowned self] in
            self.manageToken(tokenString: $0?.token)
            if let token = $0?.token, !token.isEmpty, let customerDetails = navDetails {
                self.localDataManager.saveNavDetails(details: customerDetails)
            }
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
