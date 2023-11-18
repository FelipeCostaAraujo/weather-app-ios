//
//  AppDelegateInjection.swift
//  Weather App
//
//  Created by Felipe C. Araujo on 18/11/23.
//

import Foundation

protocol AppDelegateInjection {
    
    associatedtype DelegateInjected
    
    var delegate: DelegateInjected { get }
    
    init(delegate: DelegateInjected)
    
}

extension AppDelegateInjection {
    
    init(delegate: DelegateInjected) {
        self.init(delegate: delegate)
    }
    
}
