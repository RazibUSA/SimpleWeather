//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Rimo Tech  on 4/30/23.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var city: String = ""
    @Published var weatherDataModel: WeatherModel?
    @Published var errorMessage: String = ""
    @Published var isLoading = false
    
    private let weatherFetcher: WeatherDataFetchable
    private var disposables = Set<AnyCancellable>()
    
    init(
        weatherFetcher: WeatherDataFetchable,
        scheduler: DispatchQueue = DispatchQueue(label: "WeatherViewModel")
    ) {
        self.weatherFetcher = weatherFetcher
        $city
            .dropFirst(1)
            .debounce(for: .seconds(0.5), scheduler: scheduler)
            .sink(receiveValue: fetchWeather(forCity:))
            .store(in: &disposables)
    }
    
    func fetchWeather(forCity city: String) {
        if city.isEmpty { return }
        DispatchQueue.main.async {
            self.isLoading = true
        }
       
        weatherFetcher.fetchWeatherData(for: city)
            .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] value in
          guard let self = self else { return }
          
         self.isLoading = false
          switch value {
          case .failure(let err):
              self.errorMessage = err.localizedDescription
              self.weatherDataModel = nil
          case .finished:
            break
          }
        },
        receiveValue: { [weak self] model in
          guard let self = self else { return }

          self.weatherDataModel = model
      })
      .store(in: &disposables)
  }
    
    func fetchCityName(lat: String, lon: String) {
        weatherFetcher.fetchCity(with: lat, lon: lon)
            .receive(on: DispatchQueue.main)
            .sink(
              receiveCompletion: { [weak self] value in
                guard let self = self else { return }

                switch value {
                case .failure(let err):
                    self.errorMessage = err.localizedDescription
                case .finished:
                  break
                }
              },
              receiveValue: { [weak self] model in
                guard let self = self else { return }
                  
                  if let city = model.first?.name {
                      self.fetchWeather(forCity: city)
                  }
            })
            .store(in: &disposables)
    }
}
