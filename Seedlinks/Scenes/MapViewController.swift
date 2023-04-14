//
//  MapViewController.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 02/04/23.
//

import Combine
import Foundation
import MapKit
import SnapKit
import SwiftyBeaver
import UIKit

class MapViewController: UIViewController {
    private let centerPositionButton = UIButton()
    private let mapView = MKMapView()
    private lazy var locationViewModel = LocationViewModel()
    private var cancellables: [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.register(CustomAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        setStyle()
        setConstraints()
        setRomePin()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        LocationManager.shared.start()
        centerUserPosition()
    }

    private func setStyle() {
        view.backgroundColor = .black

        mapView.overrideUserInterfaceStyle = .dark
        mapView.showsUserLocation = true

        centerPositionButton.backgroundColor = .white
        centerPositionButton.layer.cornerRadius = 20
        centerPositionButton.layer.cornerCurve = .continuous
        centerPositionButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        centerPositionButton.setTitle("Center", for: .normal)
        centerPositionButton.setTitleColor(UIColor.black, for: .normal)
        centerPositionButton.setTitleColor(UIColor.black.withAlphaComponent(0.6), for: .highlighted)
        centerPositionButton.addTarget(self, action: #selector(centerPosition), for: .touchUpInside)
    }

    @objc func centerPosition() {
        centerUserPosition()
    }

    private func centerUserPosition() {
        locationViewModel.getLastLocation()
            .first()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
                switch value {
                case .finished:
                    SwiftyBeaver.info("Finished")
                case let .failure(error):
                    SwiftyBeaver.error(error)
                }
            }, receiveValue: { self.centerMapRegion(with: $0) })
            .store(in: &cancellables)
    }

    private func centerMapRegion(with location: CLLocation) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
        }
    }

    private func setConstraints() {
        view.addSubview(mapView)
        view.addSubview(centerPositionButton)

        mapView.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }

        centerPositionButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.bottom.right.equalTo(self.view)
                .inset(UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        }
    }

    private func setRomePin() {
        let rome = CustomAnnotation()
        let image = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        rome.pinCustomImage = image
        rome.title = "Rome"
        rome.coordinate = CLLocationCoordinate2D(latitude: 41.902782, longitude: 12.496366)
        mapView.addAnnotation(rome)
    }
}

extension MapViewController: MKMapViewDelegate {}
