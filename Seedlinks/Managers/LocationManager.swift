//
//  LocationManager.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 12/04/23.
//
// swiftlint:disable line_length

import Combine
import CoreLocation
import Foundation
import SwiftyBeaver

// TODO:
/// Create a struct to handle custom error instead of using CLError
/// Add reverse geo coded funcs

class LocationManager: NSObject {
    static let shared = LocationManager()

    private let locationManager: CLLocationManager
    private var mostRecentLocationSubject = PassthroughSubject<Result<CLLocation, CLError>, Never>()
    private var locationAuthSubject = PassthroughSubject<Result<CLAuthorizationStatus, CLError>, Never>()

    override private init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }

    // For now will ask only when in use auth, in future might be needed to ask always permission
    public func requestWhenInUseAuthorization() -> AnyPublisher<CLAuthorizationStatus, CLError> {
        locationManager.requestWhenInUseAuthorization()
        return locationAuthSubject.dematerialize()
    }

    /// Request a one time user's location
    /// - Returns: a CLLocation publisher with the current location
    public func requestLocation() -> AnyPublisher<CLLocation, CLError> {
        guard isLocationAuthorized() else {
            return Fail<CLLocation, CLError>(error: CLError(.denied)).eraseToAnyPublisher()
        }
        defer { locationManager.requestLocation() }
        return locationPublisher()
    }

    /// Starts tracing the user's current location
    /// - Returns: a CLLocation publisher with the last current location
    public func traceLocationUpdates() -> AnyPublisher<CLLocation, CLError> {
        guard isLocationAuthorized() else {
            return Fail<CLLocation, CLError>(error: CLError(.denied)).eraseToAnyPublisher()
        }
        defer { locationManager.startUpdatingLocation() }
        return locationPublisher()
    }

    /// Stops updating the location
    public func stopTracingLocation() {
        locationManager.stopUpdatingLocation()
        mostRecentLocationSubject.send(completion: .finished)
    }

    public func isLocationAuthorized() -> Bool {
        locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse
    }

    public func isLocationEnabled() -> Bool {
        CLLocationManager.locationServicesEnabled()
    }

    public func isLocationDenied() -> Bool {
        locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted
    }

    public func isLocationNotDetermined() -> Bool {
        locationManager.authorizationStatus == .notDetermined
    }

    private func locationPublisher() -> AnyPublisher<CLLocation, CLError> {
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
        SwiftyBeaver.debug("\nCurrent location -> [LAT \(mostRecentLocation.coordinate.latitude)  LON \(mostRecentLocation.coordinate.longitude)]")
        mostRecentLocationSubject.send(.success(mostRecentLocation))
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError {
            locationAuthSubject.send(.failure(error))
            mostRecentLocationSubject.send(.failure(error))
            SwiftyBeaver.debug(error.localizedDescription)
        }
    }

    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationAuthSubject.send(.success(status))
        switch status {
        case .authorizedAlways:
            SwiftyBeaver.debug("authorizedAlways")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            SwiftyBeaver.debug("notDetermined")
        case .restricted:
            SwiftyBeaver.debug("restricted")
        case .denied:
            SwiftyBeaver.debug("denied")
        case .authorizedWhenInUse:
            SwiftyBeaver.debug("authorizedWhenInUse")
        @unknown default:
            SwiftyBeaver.debug("uknown")
        }
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

// swiftlint:enable line_length
