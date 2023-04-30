//
//  ViewController.swift
//  Weather
//
//  Created by Rimo Tech  on 4/29/23.
//

import UIKit
import SwiftUI
import Combine
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet var mainView: UIView!
    
    lazy var weatherViewModel = WeatherViewModel(weatherFetcher: WeatherDataFetcher())
    var cancellables = Set<AnyCancellable>()
    lazy var locationPublisher = LocationPublisher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let cityName = UserDefaults.standard.string(forKey: "cityName") {
            weatherViewModel.fetchWeather(forCity: cityName)
        } else {
            
            getUserCurrentLocation()
        }
        loadSwiftUIView()
    }
    
    func getUserCurrentLocation() {
        // observing the user's authorization status
        locationPublisher.$authorizationStatus
            .sink { currentStatus in
                self.locationAuthorization(currentStatus)
                print(currentStatus.rawValue)
            }.store(in: &cancellables)
    }

    func loadSwiftUIView() {
        let weatherView = WeatherMainView(viewModel: weatherViewModel)
        let childView = UIHostingController(rootView: weatherView)
        addChild(childView)
        childView.view.frame = mainView.bounds
        mainView.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
    
    func locationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self.locationPublisher.requestAuthorization()
        case .restricted:
            print("Sorry, restricted")
        case .denied:
            print("Sorry, denied")
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationPublisher.startMonitoringLocation()
            // observing the user's current location
            locationPublisher.$currentLocation
                .sink { currentLocation in
                    if let lat = currentLocation?.coordinate.latitude, let lon = currentLocation?.coordinate.longitude {
                        print(lat," : ", lon)
                        self.weatherViewModel.fetchCityName(lat: String(lat), lon: String(lon))
                        self.locationPublisher.stopMonitoringLocation()
                    }
                }.store(in: &cancellables)
        @unknown default:
            print("Unknown status")
        }
    }
}

