//
//  ScannerViewModel.swift
//  BarCodeScanner
//
//  Created by Manoj Karki on 11/24/20.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

protocol ScannerViewModelProtocol {
    func sendBarCodeInfo()
}

class ScannerViewModel: ScannerViewModelProtocol  {

    fileprivate var localDataManager = LoginLocalDataManager()
    fileprivate let apiDataManager = LoginAPIDataManager()
    
    var barCodeInfo = BehaviorRelay<String>(value: "")

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

}

extension ScannerViewModel {

    func sendBarCodeInfo() {

        self.isLoading.accept(true)
        
        delay(2) {
            self.communicateSuccess()
        }
    
//        apiDataManager.login(params: [:], onSuccess: { tokenResult in
//            // Save token
//        }) {
//            self.communicateError(errorMessage: $0)
//        }
    }

}
