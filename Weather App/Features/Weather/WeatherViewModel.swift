//
//  WeatherViewModel.swift
//  Weather App
//
//  Created by Felipe C. Araujo on 18/11/23.
//

import Combine

final class WeatherViewModel: ObservableObject {
    private let weatherService = WeatherService()
    
    private var city = City(lat: "-23.6814346", lon: "-46.9249599", name: "São Paulo")
    
    @Published private(set) var forecastResponse: ForecastResponse? {
        didSet {
            
        }
    }
}
