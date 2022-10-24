//
//  MapViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import MapKit
import UIKit

class MapViewModel {
    
    private let currentLocationPin = CurrentLocationPinCustomization()
    private var mapPinsModel = [MapPinsModel]()
    private var restaurantPins = MKPointAnnotation()
    
    func clearPins(_ mapView: MKMapView) {
        let annotations = mapView.annotations
        for annotation in annotations {
            mapView.removeAnnotation(annotation)
        }
    }
    
    func setUpRestaurantPins(_ mapView: MKMapView) {
        var locationData = [[String: Any]]()
        var mapPinsModel = [MapPinsModel]()
        let domainModel = RestaurantsModelController.shared.domainModel
        mapPinsModel = domainModel.map { MapPinsModel($0) }
        self.mapPinsModel = mapPinsModel
        for model in mapPinsModel {
            guard
                let name = model.name,
                let longitude = model.longitude,
                let latitude = model.latitude
            else { return }
            locationData.append(
                [
                    "name": name,
                    "latitude": latitude,
                    "longitude": longitude
                ])
        }
        
        for data in locationData {
            DispatchQueue.main.async {
                guard
                    let name = data["name"] as? String,
                    let latitude = data["latitude"] as? Double,
                    let longitude = data["longitude"] as? Double
                else { return }
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let pin = MKPointAnnotation()
                self.restaurantPins = pin
                pin.title = name
                pin.coordinate = coordinate
                mapView.addAnnotation(pin)
                let region = MKCoordinateRegion(
                    center: pin.coordinate,
                    latitudinalMeters: 10000,
                    longitudinalMeters: 10000
                )
                mapView.setRegion(region, animated: true)
            }
        }
    }
    
    func setUpCurrentLocationPin(_ mapView: MKMapView) {
        let currentLocation = LocationManager.shared.currentLocation
        currentLocationPin.pinTintColor = .systemTeal
        self.currentLocationPin.coordinate = currentLocation.coordinate
        currentLocationPin.title = "Current Location"
        mapView.addAnnotation(currentLocationPin)
    }
    
    func currentLocationButtonTriggered(_ mapView: MKMapView) {
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
    
    func setUpWebPage(with name: String?, completion: @escaping (UIViewController) -> Void) {
        let webVC = WebPageViewController()
        guard let index = mapPinsModel.firstIndex(where: { $0.name == name })else { return }
        guard let url = mapPinsModel[index].url else { return }
        webVC.setUpUrl(with: url)
        completion(webVC)
    }
    
    
    private func loadAnnotationData(
        with mapView: MKMapView,
        and annotation: MKAnnotation,
        completion: @escaping (MKMarkerAnnotationView?) -> Void
    ) {
        var annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: "myAnnotation") as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: "myAnnotation"
            )
        } else {
            annotationView?.annotation = annotation
        }
        
        completion(annotationView)
    }
    
    func loadAnnotationView(with mapView: MKMapView,and annotation: MKAnnotation, callOutButton: UIButton) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "my Annotation") as? MKMarkerAnnotationView
        
        self.loadAnnotationData(with: mapView, and: annotation, completion: { annotationData in
            annotationView = annotationData
            
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = callOutButton
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
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
