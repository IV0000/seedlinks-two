//
//  CustomAnnotation.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 12/04/23.
//

import Foundation
import MapKit

class CustomAnnotation: MKPointAnnotation {
    var pinCustomImage: UIImage!
}

class CustomAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
        update(for: annotation)
    }

    override var annotation: MKAnnotation? { didSet { update(for: annotation) } }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func update(for annotation: MKAnnotation?) {
        image = (annotation as? CustomAnnotation)?.pinCustomImage
    }
}
