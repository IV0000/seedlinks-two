//
//  LocationViewModel.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 13/04/23.
//

import Combine
import CoreLocation
import Foundation
import MapKit

class LocationViewModel {
    public func getCurrentLocation() -> AnyPublisher<CLLocation, CLError> {
        guard !LocationManager.shared.isLocationDenied() else {
            return Fail(error: CLError(.denied)).eraseToAnyPublisher()
        }
        return LocationManager.shared.requestLocation()
    }

    public func requestWhenInUseAuthorization() -> AnyPublisher<Bool, CLError> {
        guard LocationManager.shared.isLocationEnabled() else {
            return Fail(error: CLError(.locationUnknown)).eraseToAnyPublisher()
        }

        guard !LocationManager.shared.isLocationDenied() else {
            return Just(false)
                .setFailureType(to: CLError.self)
                .eraseToAnyPublisher()
        }

        return LocationManager.shared.requestWhenInUseAuthorization()
            .filter { $0 != .notDetermined }
            .first()
            .map { _ in LocationManager.shared.isLocationAuthorized() }
            .catch { error in
                if error == CLError(.denied) {
                    return Just(false).setFailureType(to: CLError.self).eraseToAnyPublisher()
                } else {
                    return Fail(error: CLError(.denied)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
