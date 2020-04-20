//
//  Observable.swift
//  Contacts
//
//  Created by Justine Tabin on 4/10/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

final class Observable<Value> {
    
    struct Observer<Value> {
        weak var observer: AnyObject?
        let block: (Value) -> Void
    }
    
    private var observers = [Observer<Value>]()
    
    var value: Value {
        didSet { notifyObservers() }
    }
    
    init(_ value: Value) {
        self.value = value
    }
    
    func observe(on observer: AnyObject, observerBlock: @escaping (Value) -> Void) {
        observers.append(Observer(observer: observer, block: observerBlock))
    }
    
    func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer && $0.observer != nil }
    }
    
    private func notifyObservers() {
        for observer in observers {
            observer.block(value)
        }
    }
}
