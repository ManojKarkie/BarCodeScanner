//
//  MessageViewModel.swift
//
//  Created by Manoj Karki on 9/25/17.
//

import RxSwift
import RxCocoa


//MARK:- Response Info View Model

struct ResponseInfoViewModel {

    fileprivate var responseData = BehaviorRelay<[ScannerResponse]>(value: [])

//    var messagesObs: Observable<[Message]> {
//       return messages.asObservable()
//    }

}


//MARK:- TableView Helpers

extension ResponseInfoViewModel {
    
    var numberOfRows: Int {
        return responseData.value.count
    }
    
    func messageAtIndex(index: Int) -> ScannerResponse {
        return responseData.value[index]
    }
}

