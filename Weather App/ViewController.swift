//
//  ViewController.swift
//  Weather App
//
//  Created by Felipe C. Araujo on 11/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var backgroundView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "background-day")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var headerView: UIView = {
        var view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var cityLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "São Paulo"
        label.textAlignment = .center
        label.textColor = UIColor(.accentColor)
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 70,weight: .bold)
        label.text = "25˚C"
        label.textAlignment = .left
        label.textColor = UIColor(.accentColor)
        return label
    }()
    
    private lazy var weatherIcon: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "sunIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var humidyLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12,weight: .semibold)
        label.text = "Umidade"
        label.textAlignment = .left
        label.textColor = UIColor(named: "contrastColor")
        return label
    }()
    
    private lazy var humidyValueLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12,weight: .semibold)
        label.text = "1000mm"
        label.textAlignment = .left
        label.textColor = UIColor(named: "contrastColor")
        return label
    }()
    
    private lazy var windLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12,weight: .semibold)
        label.text = "Vento"
        label.textAlignment = .left
        label.textColor = UIColor(named: "contrastColor")
        return label
    }()
    
    private lazy var windValueLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12,weight: .semibold)
        label.text = "10 km/h"
        label.textAlignment = .left
        label.textColor = UIColor(named: "contrastColor")
        return label
    }()
    
    
    private lazy var humidityStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ humidyLabel, humidyValueLabel ])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var windStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ windLabel, windValueLabel ])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var statsStackView: UIStackView = {
        let marginHorizontal:CGFloat = 24
        let marginVertical:CGFloat = 12
        var stackView = UIStackView(arrangedSubviews: [ humidityStackView, windStackView ] )
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = UIColor(named: "softGray")
        stackView.spacing = 3
        stackView.layer.cornerRadius = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: marginVertical, leading: marginHorizontal, bottom: marginVertical, trailing: marginHorizontal)
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {
        self.setHierarchy()
        self.setConstraints()
    }
    
    private func setHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(headerView)
        view.addSubview(statsStackView)
        headerView.addSubview(cityLabel)
        headerView.addSubview(temperatureLabel)
        headerView.addSubview(weatherIcon)
        humidityStackView.addArrangedSubview(humidyLabel)
        humidityStackView.addArrangedSubview(humidyValueLabel)
    }
    
    private func setConstraints (){
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 60),
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 35),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -35),
            headerView.heightAnchor.constraint(equalToConstant: 169),
        ])
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            cityLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            cityLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            cityLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 21),
            temperatureLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 21),
        ])
        
        NSLayoutConstraint.activate([
            weatherIcon.heightAnchor.constraint(equalToConstant: 86),
            weatherIcon.widthAnchor.constraint(equalToConstant: 86),
            weatherIcon.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -21),
            weatherIcon.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor,constant: -15),
            weatherIcon.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor, constant: 15),
        ])
        
        NSLayoutConstraint.activate([
            statsStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor,constant: 24),
            statsStackView.widthAnchor.constraint(equalToConstant: 206),
            statsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

}

