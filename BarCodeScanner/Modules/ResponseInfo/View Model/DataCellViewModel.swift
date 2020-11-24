//
//  MessageCellViewModel.swift
//
//  Created by Manoj Karki on 9/25/17.
//

import Foundation

//MARK:- Message Data Model

struct ScannerResponse {
    var dateTime: String
    var messgae: String
    var isNew: String
    var extra: String
}

protocol DataCellVmProtocol {
    
    var isEditing: Bool { get set }
    var isSelected: Bool { get set}
    var isNew: Bool? { get set }
    
    var message: String? { get  }
    var extra: String? { get  }
    var dateTimeString: String? { get }
}

//MARK:- Message TableviewCell ViewModel

struct DataCellViewModel: DataCellVmProtocol {

    fileprivate let responseInfo: ScannerResponse

    var isEditing = false
    var isSelected = false
    var isNew: Bool?

    //Initializer

    init(response: ScannerResponse) {
        self.responseInfo = response
    }

}

extension DataCellViewModel {

    var message: String? {
        return responseInfo.messgae
    }
    
    var extra: String? {
        return responseInfo.extra
    }

    var dateTimeString: String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        
        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: responseInfo.dateTime) {
            
            let targetDateFormatter = DateFormatter()
            targetDateFormatter.dateFormat = "dd MMM yyyy, hh:mma"
            
            return targetDateFormatter.string(from: date)
        }
        return nil
    }

}

