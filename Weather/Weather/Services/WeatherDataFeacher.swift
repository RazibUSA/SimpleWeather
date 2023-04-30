//
//  WeatherDataFeacher.swift
//  Weather
//
//  Created by Rimo Tech  on 4/29/23.
//

import Combine
import Foundation

import Combine
import Foundation

protocol WeatherDataFetchable{
    func fetchWeatherData(for city: String) -> AnyPublisher<WeatherModel, NetworkServiceError>
    func fetchCity(with lat: String, lon: String) -> AnyPublisher<CityModel, NetworkServiceError>
}

struct WeatherDataFetcher {
    private var networkDispatcher: Dispatchable
    
    init(networkDispatcher: Dispatchable = NetworkDispatcher()) {
        self.networkDispatcher = networkDispatcher
    }
}

extension WeatherDataFetcher: WeatherDataFetchable {
    
    func fetchWeatherData(for city: String) -> AnyPublisher<WeatherModel, NetworkServiceError> {
        return networkDispatcher.dispatch(with: makeToDayForecastComponents(with: city))
    }
    
    func fetchCity(with lat: String, lon: String) -> AnyPublisher<CityModel, NetworkServiceError> {
        return networkDispatcher.dispatch(with: makeCityNameComponents(with: lat, lon: lon))
    }
}

///
/// https://openweathermap.org/img/wn/10d@2x.png
///

private extension WeatherDataFetcher {
    struct APIConfig {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5"
        static let cityPath = "/geo/1.0"
        static let apiKey = "48cdecb12695206c8a0395dec3078eb9"
      }

    /// http://api.openweathermap.org/geo/1.0/reverse?lat=51.5098&lon=-0.1180&limit=5&appid=48cdecb12695206c8a0395dec3078eb9
    func makeCityNameComponents(with lat: String, lon: String) -> URLComponents {
      var components = URLComponents()
      components.scheme = APIConfig.scheme
      components.host = APIConfig.host
      components.path = APIConfig.cityPath + "/reverse"
      
      components.queryItems = [
        URLQueryItem(name: "lat", value: lat),
        URLQueryItem(name: "lon", value: lon),
        URLQueryItem(name: "APPID", value: APIConfig.apiKey)
      ]
      
      return components
    }

    ///https://api.openweathermap.org/data/2.5/weather?q=plano&appid=48cdecb12695206c8a0395dec3078eb9
    func makeToDayForecastComponents(with city: String) -> URLComponents {
      var components = URLComponents()
      components.scheme = APIConfig.scheme
      components.host = APIConfig.host
      components.path = APIConfig.path + "/weather"
      
      components.queryItems = [
        URLQueryItem(name: "q", value: city),
        URLQueryItem(name: "units", value: "imperial"),
//        URLQueryItem(name: "units", value: "metric"),
        URLQueryItem(name: "APPID", value: APIConfig.apiKey)
      ]
      print(components)
      return components
    }
}
