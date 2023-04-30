//
//  NetworkDispatcher.swift
//  Weather
//
//  Created by Rimo Tech  on 4/29/23.
//

import Combine
import Foundation

//MARK: Protocol
protocol Dispatchable {
    func dispatch<T: Codable>(with components: URLComponents) -> AnyPublisher<T, NetworkServiceError>
}

//MARK: - REST service request
struct NetworkDispatcher: Dispatchable {
    
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    /// A generic Dispatches an URLRequest and returns a publisher
    func dispatch<T: Codable>(with components: URLComponents) -> AnyPublisher<T, NetworkServiceError> {
        guard let request = components.url else {
            let error = NetworkServiceError.badRequest
              return Fail(error: error).eraseToAnyPublisher()
            }
        
        return urlSession
            .dataTaskPublisher(for: request)
            .tryMap({ data, response in
                if let response = response as? HTTPURLResponse,
                   !(200...299).contains(response.statusCode) {
                    throw httpError(response.statusCode)
                }
                
                return data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                handleError(error)
            }
            .eraseToAnyPublisher()
    }
}

//MARK: - Private helper function
private extension NetworkDispatcher {
    /// Parses a HTTP StatusCode and returns a proper error
    func httpError(_ statusCode: Int) -> NetworkServiceError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
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

#if DEBUG
//MARK: Tests
extension NetworkDispatcher {
    struct TestHooks {
        let target: NetworkDispatcher
        
        func httpError(_ statusCode: Int) -> NetworkServiceError {
            target.httpError(statusCode)
        }
        
        func handleError(_ error: Error) -> NetworkServiceError {
            target.handleError(error)
        }
    }
    
    var testHooks: TestHooks {
        TestHooks(target: self)
    }
}
#endif
