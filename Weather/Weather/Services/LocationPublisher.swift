//
//  LocationPublisher.swift
//  Weather
//
//  Created by Rimo Tech  on 4/29/23.
//

import Foundation
import Combine
import CoreLocation

/// https://www.waldo.com/blog/building-a-location-publisher-with-combine-and-core-location

class LocationPublisher: NSObject, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager

        @Published private(set) var currentLocation: CLLocation?
        @Published private(set) var authorizationStatus: CLAuthorizationStatus

        init(locationManager: CLLocationManager = CLLocationManager()) {
            self.locationManager = locationManager
            self.authorizationStatus = locationManager.authorizationStatus

            super.init()

            locationManager.delegate = self
        }
    
    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func startMonitoringLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopMonitoringLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            self.authorizationStatus = manager.authorizationStatus
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            self.currentLocation = locations.last
        }
}
