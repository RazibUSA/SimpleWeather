//
//  MockData.swift
//  WeatherTests
//
//  Created by Rimo Tech  on 4/29/23.
//

import Foundation
import Combine
@testable import Weather

struct MockNetworkDispatcher: Dispatchable {
    
    let jsonResponse = """
    {
      "coord": {
        "lon": -96.6989,
        "lat": 33.0198
      },
      "weather": [
        {
          "id": 800,
          "main": "Clear",
          "description": "clear sky",
          "icon": "01d"
        }
      ],
      "base": "stations",
      "main": {
        "temp": 293.68,
        "feels_like": 292.78,
        "temp_min": 292.69,
        "temp_max": 294.66,
        "pressure": 1013,
        "humidity": 38
      },
      "visibility": 10000,
      "wind": {
        "speed": 5.66,
        "deg": 330,
        "gust": 8.23
      },
      "clouds": {
        "all": 0
      },
      "dt": 1682812987,
      "sys": {
        "type": 2,
        "id": 2009819,
        "country": "US",
        "sunrise": 1682768479,
        "sunset": 1682816806
      },
      "timezone": -18000,
      "id": 4719457,
      "name": "Plano",
      "cod": 200
    }
    """.data(using: .utf8)
    
    
    func dispatch<T>(with components: URLComponents) -> AnyPublisher<T, NetworkServiceError> where T : Decodable, T : Encodable {
        
        guard let jsonData = jsonResponse else {
            return Fail(error: .badRequest).eraseToAnyPublisher()
        }
        
        return Just(jsonData)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                handleError(error)
            }
            .eraseToAnyPublisher()
        
    }
        
        func handleError(_ error: Error) -> NetworkServiceError {
            switch error {
            case is Swift.DecodingError:
                return .decodingError(error.localizedDescription)
            case let urlError as URLError:
                return .urlSessionFailed(urlError)
            case let error as NetworkServiceError:
                return error
            default:
                return .unknownError
            }
        }
    
}
