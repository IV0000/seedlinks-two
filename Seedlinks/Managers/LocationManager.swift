//
//  LocationManager.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 12/04/23.
//

import Combine
import CoreLocation
import Foundation
import SwiftyBeaver

// TODO:
/// Create a struct to handle custom error instead of using Error struct
/// Review the access levels of funcs and vars

class LocationManager: NSObject {
    static let shared = LocationManager()

    private let locationManager: CLLocationManager
    private var mostRecentLocationSubject = CurrentValueSubject<Result<CLLocation, Error>, Never>(Result.success(CLLocation())) // Fix: when I open the app I have the map centered to ocean

    override private init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        super.init()
        locationManager.delegate = self
    }

    func start() {
        // Rewrite in a different method
        locationManager.requestAlwaysAuthorization()
    }

    /// Starts updating the current location
    /// - Returns: a location publisher with the last current location
    public func traceLocation() -> AnyPublisher<CLLocation, Error> {
        defer { locationManager.startUpdatingLocation() }
        return locationPublisher()
    }

    private func locationPublisher() -> AnyPublisher<CLLocation, Error> {
        mostRecentLocationSubject
            .dematerialize()
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        SwiftyBeaver.debug("Recent location \(mostRecentLocation)")
        mostRecentLocationSubject.send(.success(mostRecentLocation))
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        mostRecentLocationSubject.send(.failure(error))
        SwiftyBeaver.debug(error.localizedDescription)
//        locationManager.stopUpdatingLocation()
    }

    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        SwiftyBeaver.debug(status)
    }
}

// MARK: https://forums.swift.org/t/result-subscriber/29868/9

extension Publisher {
    func dematerialize<S, E>() -> AnyPublisher<S, E> where Self.Output == Result<S, E>, Self.Failure == Never {
        setFailureType(to: E.self)
            .flatMap { Result.Publisher($0) }
            .eraseToAnyPublisher()
    }
}
