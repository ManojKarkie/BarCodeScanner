//
//  LoginProtocols.swift
//
//  Created Manoj Karki on 5/19/20.
//
//

import Foundation
import UIKit

//MARK: Coordinator -
protocol LoginCoordinatorProtocol: class {
    
    /**
     * Add here your methods for communication from VIEW -> COORDINATOR
     */
    
    func showScanner()
    func gotoForgotPassword()
    func gotoSignup()

}

//MARK: View Model -
protocol LoginViewModelProtocol: class {
    /**
     * Add here your methods for communication VIEW -> VIEW MODEL
     */

    func login()
}

//MARK: API -
protocol LoginAPIDataManagerInputProtocol: class {
    /**
     * Add here your methods for communication  VIEWMODEL -> APIDATAMANAGER
     */
    // Data fetch functions from server

    
    func login(params: [String: String], onSuccess: ((String?) -> Void)?, onError: ((_ errorMessage: String?) -> Void)?)
  
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
}
