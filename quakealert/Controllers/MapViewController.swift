//
//  MapViewController.swift
//  quakealert
//
//  Created by EMTECH MAC on 18/07/2024.
//

import UIKit
import MapKit
import RxSwift

class MapViewController: UIViewController, MKMapViewDelegate {

    var earthquakes: [Earthquake] = []
    var selectedEarthquake: Earthquake?
    private let viewModel = EarthquakeViewModel(apiManager: APIManager())
    private let disposeBag = DisposeBag()
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        mapView.delegate = self
        bindViewModel()
        viewModel.fetchAPI.onNext(())
    }

    private func setupUI() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(openSearchViewController))
    }

    @objc private func openSearchViewController() {
        let searchViewController = SearchViewController(viewModel: viewModel)
        navigationController?.pushViewController(searchViewController, animated: true)
    }

    private func bindViewModel() {
        viewModel.data
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] earthquakes in
                self?.earthquakes = earthquakes
                if let selectedEarthquake = self?.selectedEarthquake {
                    self?.showEarthquakeLocationOnMap(selectedEarthquake)
                } else {
                    self?.showAllEarthquakesOnMap()
                }
            })
            .disposed(by: disposeBag)
    }

    private func showEarthquakeLocationOnMap(_ earthquake: Earthquake) {
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.title = "Magnitude: \(earthquake.mag)"
        annotation.subtitle = """
        Place: \(earthquake.place)
        Time: \(Date(timeIntervalSince1970: TimeInterval(earthquake.time)))
        Coordinates: \(earthquake.latitude), \(earthquake.longitude)
        """
        annotation.coordinate = CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude)
        mapView.addAnnotation(annotation)

        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
        mapView.setRegion(region, animated: true)
    }

    private func showAllEarthquakesOnMap() {
        mapView.removeAnnotations(mapView.annotations)
        var coordinates = [CLLocationCoordinate2D]()
        for earthquake in earthquakes {
            let annotation = MKPointAnnotation()
            annotation.title = "Magnitude: \(earthquake.mag)"
            annotation.subtitle = """
            Place: \(earthquake.place)
            Time: \(Date(timeIntervalSince1970: TimeInterval(earthquake.time)))
            Coordinates: \(earthquake.latitude), \(earthquake.longitude)
            """
            annotation.coordinate = CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude)
            mapView.addAnnotation(annotation)
            coordinates.append(annotation.coordinate)
        }
        if let firstCoordinate = coordinates.first {
            let region = MKCoordinateRegion(center: firstCoordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
            mapView.setRegion(region, animated: true)
        }
    }

    // MKMapViewDelegate method for custom annotation view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "EarthquakeAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
}

