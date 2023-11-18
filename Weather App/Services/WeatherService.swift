//
//  HttpWeatherService.swift
//  Weather App
//
//  Created by Felipe C. Araujo on 18/11/23.
//

import Foundation

struct City {
    let lat: String
    let lon: String
    let name: String
}

class WeatherService {
    
    private let baseURL: String = "https://api.openweathermap.org/data/3.0/onecall"
    private let apiKey: String = ""
    private let session = URLSession.shared
    
    func fetchData(city: City, _ completion: @escaping (Result<ForecastResponse, Error>) -> Void) {
            let urlString = "\(baseURL)?lat=\(city.lat)&lon=\(city.lon)&appid=\(apiKey)&units=metric"
            guard let url = URL(string: urlString) else { return }
            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Falha na resposta HTTP com status code: \(httpResponse.statusCode)"])))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Dados não recebidos"])))
                    return
                }
                
                print(data)

                do {
                    let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                    completion(.success(forecastResponse))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    
}

// MARK: - ForecastResponse
struct ForecastResponse: Codable {
    let current: Forecast
    let hourly: [Forecast]
    let daily: [DailyForecast]
}

// MARK: - Forecast
struct Forecast: Codable {
    let dt: Int
    let temp: Double
    let humidity: Int
    let windSpeed: Double
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt, temp, humidity
        case windSpeed = "wind_speed"
        case weather
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - DailyForecast
struct DailyForecast: Codable {
    let dt: Int
    let temp: Temp
    let weather: [Weather]
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}
