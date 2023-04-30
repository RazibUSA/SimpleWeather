//
//  LocalDispatcher.swift
//  Weather
//
//  Created by Rimo Tech  on 4/29/23.
//

import Foundation
import Combine

/// Main purpose of this class to load and save data from local
///  As the scope of this Project is Only save city  name
///  I am using Userdefault
///  but for complex object FileManager - documentDirectory
///  Incase of sensetive Data - Keychain

extension UserDefaults {
    @objc dynamic var cityName: Int {
        return integer(forKey: "cityName")
    }
}

/// Credit goes to - https://gist.github.com/malhal/22f534d47d620216c25d812af9bcc227

import CoreLocation

extension CLLocationManager {
    public static func publishLocation() -> LocationPublisher{
        return .init()
    }

    public struct LocationPublisher: Publisher {
        public typealias Output = CLLocation
        public typealias Failure = Never

        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = LocationSubscription(subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
        
        final class LocationSubscription<S: Subscriber> : NSObject, CLLocationManagerDelegate, Subscription where S.Input == Output, S.Failure == Failure{
            var subscriber: S
            var locationManager = CLLocationManager()
            
            init(subscriber: S) {
                self.subscriber = subscriber
                super.init()
                locationManager.delegate = self
            }

            func request(_ demand: Subscribers.Demand) {
                locationManager.startUpdatingLocation()
                locationManager.requestWhenInUseAuthorization()
            }
            
            func cancel() {
                locationManager.stopUpdatingLocation()
            }
            
            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                for location in locations {
                    _ = subscriber.receive(location)
                }
            }
        }
    }
}
