//
//  Views.swift
//  IME Motors
//
//  Created by Manoj Karki on 5/27/20.
//  Copyright © 2020 IME Motors. All rights reserved.
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
