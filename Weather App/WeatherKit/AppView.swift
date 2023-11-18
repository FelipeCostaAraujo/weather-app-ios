//
//  AppView.swift
//  Weather App
//
//  Created by Felipe C. Araujo on 18/11/23.
//

import Foundation

protocol AppView {
    func setupView()
    
    func setHierarchy()
    func setConstraints()
}

extension AppView {
    func setupView() {
        setHierarchy()
        setConstraints()
    }
}
