//
//  WeatherViewController.swift
//  Weather App
//
//  Created by Felipe C. Araujo on 18/11/23.
//

import UIKit
import MapKit
import Combine

class WeatherViewController: UIViewController {
    
    // MARK: View
    typealias CustomView = WeatherView
    
    private var customView: CustomView { view as! CustomView }
    private let service = WeatherService()
    private let viewModel:WeatherViewModel!
    private var cancellables: Set<AnyCancellable> = []
    private var locationManager = CLLocationManager()
    private var forecastResponse: ForecastResponse?
    private var city = City(lat: "0", lon: "0", name: "")
    
    override func loadView() {
        view = CustomView(configuration: WeatherViewDelegate(delegate: self))
    }
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func retryButtonTapped() {
        hideError()
        viewModel.fetchData(city)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        bindViewModel()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        locationManager.startUpdatingLocation()
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
            customView.headerView.backgroundColor = .black
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
    
    //MARK: Alerts
    private func showAlert(with message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func showLocationAlert(){
        let alertController = UIAlertController(title: "Permissão de localização", message: "Necessario permissão para acesso à sua localizão!! por favir habilite.", preferredStyle: .alert)
        let acaoConfiguracoes = UIAlertAction(title: "Abrir Configurações", style: .default) { (alertaConfiracoes) in
            if let configuracoes = NSURL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(configuracoes as URL)
            }
        }
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        alertController.addAction(acaoConfiguracoes)
        alertController.addAction(acaoCancelar)
        
        present(alertController,animated: true,completion: nil)
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

//MARK: Data
extension WeatherViewController {
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .idle:
                    break
                case .loading:
                    self?.showLoader()
                    break
                case .loaded(let forecastResponse):
                    self?.forecastResponse = forecastResponse
                    self?.hideLoader()
                    self?.loadData()
                    break
                case .error(let error):
                    self?.handleError(error)
                    break
                }
            }
            .store(in: &cancellables)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showLocationAlert()
            break
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localizacaoUsuario: CLLocation = locations.last!
        
        let latitude = localizacaoUsuario.coordinate.latitude
        let longitude = localizacaoUsuario.coordinate.longitude
        
        city.lat = String(format: "%f", latitude)
        city.lon = String(format: "%f", longitude)
        
        CLGeocoder().reverseGeocodeLocation(localizacaoUsuario) { [self] (localityDetails, erro) in
            if erro == nil {
                if let localityData = localityDetails?.first {
                    if let locality = localityData.locality {
                        self.city.name = locality
                    }
                }
                viewModel.fetchData(city)
                locationManager.stopUpdatingLocation()
            } else{
                print("não foi possivel exibir o endereço")
            }
        }
        
    }
}
