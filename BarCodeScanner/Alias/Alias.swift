//
//  Alias.swift
//
//  Created by Manoj Karki on 5/28/20.
//

import Foundation
import ObjectMapper

typealias VoidClosure = (() -> Void)?

typealias apiResultHandler<M: Mappable> = ((Result<M?, Error>) -> Void)?
