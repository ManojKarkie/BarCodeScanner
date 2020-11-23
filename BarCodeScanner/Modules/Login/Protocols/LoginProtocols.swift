//
//  LoginProtocols.swift
//  IME Motors
//
//  Created Manoj Karki on 5/19/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//
//

import Foundation
import UIKit

//MARK: Coordinator -
protocol LoginCoordinatorProtocol: class {
    
    /**
     * Add here your methods for communication from VIEW -> COORDINATOR
     */

    func showVerifyCustomerCodePopUp(onVerify: ((VerifyCustomerCodeFormInfo) -> Void)? )
    func gotoProfile()
    func gotoForgotPassword()
    func gotoSettings()
    func gotoSignup()
}

//MARK: View Model -
protocol LoginViewModelProtocol: class {
    /**
     * Add here your methods for communication VIEW -> VIEW MODEL
     */
    func signInWithGoogle()
    func authenticateExternalLogin(token: String?, loginType: SocialLoginType, profileData: UserProfile)
    func manageFacebookProfile(userDetails: Any?)
    func login()
    func verifyAndLoginWithCustomerCode(customerInfo: VerifyCustomerCodeFormInfo)
}

//MARK: API -
protocol LoginAPIDataManagerInputProtocol: class {
    /**
     * Add here your methods for communication  VIEWMODEL -> APIDATAMANAGER
     */
    // Data fetch functions from server

    func authExternalLogin(params: [String: String], onSuccess: ((Token?) -> Void)?, onError: ((_ errorMessage: String?) -> Void)?)
    func login(params: [String: String], onSuccess: ((TokenResult?) -> Void)?, onError: ((_ errorMessage: String?) -> Void)?)
    func verifyCustomerCode(params: [String: String], onSuccess: ((NavCustomerDetail?) -> Void)?, onError: ((_ errorMessage: String?) -> Void)?)
    func loginWithCustomerCode(params: [String: String], onSuccess: ((Token?) -> Void)?, onError: ((_ errorMessage: String?) -> Void)?)
}

//MARK: Local -
protocol LoginLocalDataManagerInputProtocol: class {
    /**
     * Add here your methods for communication VIEWMODEL -> LOCALDATAMANAGER
     */
    // Data fetch functions from local database
    
    var realmDataManager: RealmDataManager { get set }
    var keychainService: KeychainService { get set }
    func managerUserProfile(profile: UserProfile)
    func saveToken(tokenString: String)
    func saveNavDetails(details: NavCustomerDetail)
}
