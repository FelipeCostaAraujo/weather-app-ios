//
//  WeatherViewModel.swift
//  Weather App
//
//  Created by Felipe C. Araujo on 18/11/23.
//

import Combine

final class WeatherViewModel {
    enum State {
        case idle
        case loading
        case loaded(ForecastResponse)
        case error(Error)
    }
    
    private var city = City(lat: "-23.6814346", lon: "-46.9249599", name: "São Paulo")
    
    @Published private(set) var state: State = .idle
    private let weatherService: WeatherService
    private var cancellables = Set<AnyCancellable>()
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func fetchData() {
        state = .loading
        weatherService.fetchForecast(city: city)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.state = .error(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] forecastResponse in
                self?.state = .loaded(forecastResponse)
            })
            .store(in: &cancellables)
    }
}
