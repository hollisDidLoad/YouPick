//
//  MapViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private let contentView = MapView()
    private let viewModel = MapViewModel()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        contentView.currentLocationButton.addTarget(
            self,
            action: #selector(currentLocationButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc
    private func currentLocationButtonTapped() {
        contentView.zoomToCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        contentView.mapView.delegate = self
        contentView.setUpCurrentLocationPin()
        guard let pinsData = viewModel.setUpRestaurantPinsData(with: contentView.mapView) else { return }
        contentView.setUpRestaurantsPins(with: pinsData)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        contentView.clearPins()
    }
}

//MARK: - Map View Delegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        let pin = view.annotation
        guard let title = pin?.title else { return }
        contentView.setUpWebPage(with: title, and: viewModel.mapPinsModel ,completion: { [weak self] webVC in
            self?.present(webVC, animated: true)
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotationData = viewModel.loadAnnotationData(with: mapView, and: annotation) else { return nil }
        return contentView.loadAnnotationView(with: annotation, and: annotationData)
    }
}
