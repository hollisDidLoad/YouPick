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
        viewModel.currentLocationButtonTriggered(contentView.mapView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        contentView.mapView.delegate = self
        viewModel.setUpCurrentLocationPin(contentView.mapView)
        viewModel.setUpRestaurantPins(contentView.mapView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.clearPins(contentView.mapView)
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
        viewModel.setUpWebPage(with: title, completion: { [weak self] webVC in
            self?.present(webVC, animated: true)
        })
    }
    
    func mapView(_ mapView: MKMapView,viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: "myAnnotation") as? MKMarkerAnnotationView
        
        self.viewModel.loadAnnotationData(
            with: mapView,
            and: annotation,
            completion: { updatedAnnotationView in
                annotationView = updatedAnnotationView
                
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = self.contentView.webButton
                
                if annotationView == nil {
                    annotationView = MKMarkerAnnotationView(
                        annotation: annotation,
                        reuseIdentifier: "myAnnotation"
                    )
                } else {
                    annotationView?.annotation = annotation
                }
                
                if let annotation = annotation as? CurrentLocationPinCustomization {
                    annotationView?.markerTintColor = annotation.pinTintColor
                }
            })
        return annotationView
    }
}
