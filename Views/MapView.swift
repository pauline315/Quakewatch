//
//  MapView.swift
//  quakealert
//
//  Created by EMTECH MAC on 03/07/2024.
//

import UIKit
import MapKit

class MapView: UIView {
    let mapView = MKMapView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func update(with earthquakes: [Earthquake]) {
        let annotations = earthquakes.map { earthquake -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude)
            annotation.title = "Magnitude: \(earthquake.mag)"
            annotation.subtitle = earthquake.place
            return annotation
        }
        mapView.addAnnotations(annotations)
    }
}
