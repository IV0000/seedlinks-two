//
//  MapViewController.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 02/04/23.
//

import MapKit
import SnapKit
import UIKit

class MapViewController: UIViewController {
    private let centerPositionButton = UIButton()
    private let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.register(CustomAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        setStyle()
        setConstraints()
        setRomePin()
    }

    private func setStyle() {
        view.backgroundColor = .black

        mapView.overrideUserInterfaceStyle = .dark

        centerPositionButton.backgroundColor = .white
        centerPositionButton.layer.cornerRadius = 20
        centerPositionButton.layer.cornerCurve = .continuous
        centerPositionButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        centerPositionButton.setTitle("Center", for: .normal)
        centerPositionButton.setTitleColor(UIColor.black, for: .normal)
        centerPositionButton.setTitleColor(UIColor.black.withAlphaComponent(0.6), for: .highlighted)
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
