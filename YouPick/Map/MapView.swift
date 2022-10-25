//
//  MapView.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit
import MapKit

class MapView: UIView {
    
    let webButton = UIButton(type: .infoDark)
    
    let currentLocationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let largeConfig = UIImage.SymbolConfiguration(
            pointSize: 50,
            weight: .bold,
            scale: .large
        )
        button.tintColor = .systemTeal
        let buttonImage = UIImage(systemName: "location.magnifyingglass", withConfiguration: largeConfig)
        button.setImage(buttonImage, for: .normal)
        return button
    }()
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(mapView)
        addSubview(currentLocationButton)
        
        currentLocationButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -20).isActive = true
        currentLocationButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20).isActive = true
        currentLocationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        currentLocationButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    func setUpWebPage(
        with name: String?,
        and mapPinsModel: [MapPinsModel],
        completion: @escaping (UIViewController) -> Void
    ) {
        let webVC = WebPageViewController()
        guard let index = mapPinsModel.firstIndex(where: { $0.name == name }) else { return }
        guard let url = mapPinsModel[index].url else { return }
        webVC.setUpUrl(with: url)
        completion(webVC)
    }
    
    func clearPins() {
        let annotations = mapView.annotations
        for annotation in annotations {
            mapView.removeAnnotation(annotation)
        }
    }
    
    func zoomToCurrentLocation() {
        let currentLocation = LocationManager.shared.currentLocation
        let center = CLLocationCoordinate2D(
            latitude: currentLocation.coordinate.latitude,
            longitude: currentLocation.coordinate.longitude
        )
        let region = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            ))
        
        mapView.setRegion(region, animated: true)
    }
    
    func setUpRestaurantsPins(with region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
    
    func setUpCurrentLocationPin() {
        let currentLocationPin = CurrentLocationPinCustomization()
        let currentLocation = LocationManager.shared.currentLocation
        currentLocationPin.pinTintColor = .systemTeal
        currentLocationPin.coordinate = currentLocation.coordinate
        currentLocationPin.title = "Current Location"
        mapView.addAnnotation(currentLocationPin)
    }
    
    func loadAnnotationView(
        with annotation: MKAnnotation,
        and annotationData: MKMarkerAnnotationView
    ) -> (MKAnnotationView?
    ) {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "my Annotation") as? MKMarkerAnnotationView
        
        annotationView = annotationData
        annotationView?.canShowCallout = true
        annotationView?.rightCalloutAccessoryView = webButton
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
        } else {
            annotationView?.annotation = annotation
        }
        
        if let annotation = annotation as? CurrentLocationPinCustomization {
            annotationView?.markerTintColor = annotation.pinTintColor
        }
        return annotationView
    }
}
