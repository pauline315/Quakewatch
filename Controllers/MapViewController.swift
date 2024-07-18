//
//  MapViewController.swift
//  quakealert
//
//  Created by EMTECH MAC on 03/07/2024.
//

import UIKit

class MapViewController: UIViewController {
    private let viewModel = EarthquakeViewModel()
    private let mapView = MapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        viewModel.fetchEarthquakeData()
    }

    private func setupView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            self.mapView.update(with: self.viewModel.earthquakeList)
        }
    }
}
