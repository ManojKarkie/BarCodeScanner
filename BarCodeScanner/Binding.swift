//
//  Binding.swift
//
//  Created by Manoj Karki on 11/20/17.
//

import RxSwift
import RxCocoa

infix operator <-> : DefaultPrecedence

func <-> <T>(property: ControlProperty<T>, variable: BehaviorRelay<T>) -> Disposable {

    let bindToUIDisposable = variable.asObservable()
        .bind(to: property)
    let bindToVariable = property
        .subscribe(onNext: { n in
            variable.accept(n)
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToVariable)
}
