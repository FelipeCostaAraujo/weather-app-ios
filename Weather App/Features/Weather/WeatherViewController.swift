//
//  WeatherViewController.swift
//  Weather App
//
//  Created by Felipe C. Araujo on 18/11/23.
//

import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: View
    typealias CustomView = WeatherView
    
    private var customView: CustomView { view as! CustomView }
    
    override func loadView() {
        view = CustomView(configuration: WeatherViewDelegate(delegate: self))
    }
    
    @objc private func retryButtonTapped() {
        hideError()
        fetchData()
    }
    
    private let service = WeatherService()
    private var city = City(lat: "-23.6814346", lon: "-46.9249599", name: "São Paulo")
    private var forecastResponse: ForecastResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        fetchData()
    }
    
    private func fetchData() {
        showLoader()
        
        service.fetchData(city: city) { [weak self] result in
            DispatchQueue.main.async {
                self?.hideLoader()
                switch result {
                case .success(let forecastResponse):
                    self?.forecastResponse = forecastResponse
                    self?.loadData()
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }
    
    private func handleError(_ error: Error) {
        showError()
        let nsError = error as NSError
        var message = "Ocorreu um erro ao buscar os dados do tempo."
        
        if nsError.domain == NSURLErrorDomain {
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet:
                message = "Sem conexão com a internet. Por favor, verifique sua conexão e tente novamente."
            case NSURLErrorTimedOut:
                message = "A requisição demorou muito para responder. Por favor, tente novamente mais tarde."
            default:
                message = "Erro de conexão: \(nsError.localizedDescription)"
            }
        } else {
            message = "Erro: \(nsError.localizedDescription)"
        }
        showAlert(with: message)
    }
    
    private func showAlert(with message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func loadData() {
        customView.cityLabel.text = city.name
        
        customView.temperatureLabel.text = forecastResponse?.current.temp.toCelsius()
        customView.humidityValueLabel.text = "\(forecastResponse?.current.humidity ?? 0)mm"
        customView.windValueLabel.text = "\(forecastResponse?.current.windSpeed ?? 0)km/h"
        customView.weatherIcon.image = UIImage(named: forecastResponse?.current.weather.first?.icon ?? "")
        
        
        if forecastResponse?.current.dt.isDayTime() ?? true {
            customView.backgroundView.image = UIImage(named:"background-day")
        } else {
            customView.backgroundView.image = UIImage(named: "background-night")
        }
        
        customView.hourlyCollectionView.reloadData()
        customView.dailyForecastTableView.reloadData()
        
        hideLoader()
    }
    
    private func showLoader() {
        customView.retryButton.isHidden = true
        customView.loaderView.isHidden = false
        customView.loader.isHidden = false
        customView.loader.startAnimating()
    }
    
    private func hideLoader() {
        customView.loaderView.isHidden = true
        customView.loader.isHidden = true
        customView.loader.stopAnimating()
    }
    
    func showError() {
        customView.loaderView.isHidden = false
        customView.retryButton.isHidden = false
    }
    
    func hideError() {
        customView.loaderView.isHidden = true
        customView.retryButton.isHidden = true
    }

}


extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecastResponse?.hourly.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCollectionViewCell.identifier,
                                                            for: indexPath) as? HourlyForecastCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let forecast = forecastResponse?.hourly[indexPath.row]
        cell.loadData(time: forecast?.dt.toHourFormat(),
                      icon: UIImage(named: forecast?.weather.first?.icon ?? ""),
                      temp: forecast?.temp.toCelsius())
        return cell
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecastResponse?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastTableViewCell.identifier,
                                                       for: indexPath) as? DailyForecastTableViewCell else {
            return UITableViewCell()
        }
        
        let forecast = forecastResponse?.daily[indexPath.row]
        cell.loadData(weekDay: forecast?.dt.toWeekdayName().uppercased(),
                      min: forecast?.temp.min.toCelsius(),
                      max: forecast?.temp.max.toCelsius(),
                      icon: UIImage(named: forecast?.weather.first?.icon ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
