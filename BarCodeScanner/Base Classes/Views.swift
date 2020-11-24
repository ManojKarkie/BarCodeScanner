//
//  Views.swift
//
//  Created by Manoj Karki on 5/27/20.
//

import Foundation
import UIKit

class RoundedWhiteView: UIView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStandardRoundedCorner()
        self.backgroundColor = .white
    }
    
}
