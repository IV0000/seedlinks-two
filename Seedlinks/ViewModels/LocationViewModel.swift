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
    func getLastLocation() -> AnyPublisher<CLLocation, Error> {
        LocationManager.shared.traceLocation()
    }
}
