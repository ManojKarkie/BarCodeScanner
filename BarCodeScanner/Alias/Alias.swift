//
//  Alias.swift
//  IME Motors
//
//  Created by Manoj Karki on 5/28/20.
//  Copyright © 2020 IME Motors. All rights reserved.
//

import Foundation
import ObjectMapper

typealias VoidClosure = (() -> Void)?

typealias apiResultHandler<M: Mappable> = ((Result<M?, Error>) -> Void)?
