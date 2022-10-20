//
//  MapViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit
import MapKit

class MapViewModel {
    
    let currentLocationPin = CurrentLocationPinCustomization()
    var domainModel = RestaurantsModelController.shared.domainModel
    var restaurantPins = MKPointAnnotation()
    
    func clearPins(_ mapView: MKMapView) {
        let annotations = mapView.annotations
        for annotation in annotations {
            mapView.removeAnnotation(annotation)
        }
    }
    
    func setUpRestaurantPins(_ mapView: MKMapView) {
        var locationData = [[String: Any]]()
        let domainModel = RestaurantsModelController.shared.domainModel
        self.domainModel = domainModel
        for model in domainModel {
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
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let pin = MKPointAnnotation()
                self.restaurantPins = pin
                pin.title = name
                pin.coordinate = location
                mapView.addAnnotation(pin)
                let region = MKCoordinateRegion(
                    center: pin.coordinate,
                    latitudinalMeters: 10000,
                    longitudinalMeters: 10000)
                mapView.setRegion(region, animated: true)
            }
        }
    }
    
    func setUpCurrentLocationPin(_ mapView: MKMapView) {
        let currentLocation = LocationManagerViewController.shared.currentLocation
        currentLocationPin.pinTintColor = .systemTeal
        self.currentLocationPin.coordinate = currentLocation.coordinate
        currentLocationPin.title = "Current Location"
        mapView.addAnnotation(currentLocationPin)
    }
    
    func currentLocationButtonTriggered(_ mapView: MKMapView) {
        let currentLocation = LocationManagerViewController.shared.currentLocation
        let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
    }
    
    func setUpWebPage(with title: String?, completion: @escaping (UIViewController) -> Void) {
        let webVC = WebPageViewController()
        guard let index = domainModel.firstIndex(where: { $0.name == title }) else { return }
        guard let url = domainModel[index].url else { return }
        webVC.setUpUrl(with: url)
        completion(webVC)
    }
}
