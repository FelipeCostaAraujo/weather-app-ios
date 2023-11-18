//
//  WeatherViewDelegate.swift
//  Weather App
//
//  Created by Felipe C. Araujo on 18/11/23.
//

import Foundation

struct WeatherViewDelegate: AppDelegateInjection {
    
    typealias DelegateInjected = WeatherViewController
    
    var delegate: DelegateInjected
    
}
