//
//  WeatherDataFeacherTests.swift
//  WeatherTests
//
//  Created by Rimo Tech  on 4/29/23.
//

import XCTest
@testable import Weather

final class WeatherDataFeacherTests: XCTestCase {

    var dataFetcher: WeatherDataFetcher!

    override func setUpWithError() throws {
        dataFetcher = WeatherDataFetcher(networkDispatcher: MockNetworkDispatcher() as Dispatchable)
    }

    func testWeatherDataResponse() throws {
        let expectation = XCTestExpectation(description: "Weather Request Test")
        
        _ = dataFetcher.fetchWeatherData(for: "Plano")
            .sink(receiveCompletion: { _ in}) { response  in
                
                XCTAssertEqual(response.main.temp, 293.68)
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 1)
    }
}
