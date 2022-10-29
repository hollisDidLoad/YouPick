//
//  MapViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import MapKit

class MapViewModel {
    
    var mapPinsModel = [MapPinsModel]()
    private var modelController: RestaurantsModelController
    
    init(modelController: RestaurantsModelController) {
        self.modelController = modelController
    }
    
    func setUpRestaurantPinsData(with mapView: MKMapView) -> MKCoordinateRegion? {
        var locationData = [[String: Any]]()
        var mapPinsModel = [MapPinsModel]()
        var mapRegion: MKCoordinateRegion?
        let domainModel = modelController.domainModels
        mapPinsModel = domainModel.map { MapPinsModel($0) }
        self.mapPinsModel = mapPinsModel
        
        for model in mapPinsModel {
            guard
                let name = model.name,
                let longitude = model.longitude,
                let latitude = model.latitude
            else { return nil }
            locationData.append(
                [
                    "name": name,
                    "latitude": latitude,
                    "longitude": longitude
                ])
        }
        
        for data in locationData {
            guard
                let name = data["name"] as? String,
                let latitude = data["latitude"] as? Double,
                let longitude = data["longitude"] as? Double
            else { return nil }
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let pin = MKPointAnnotation()
            pin.title = name
            pin.coordinate = coordinate
            mapView.addAnnotation(pin)
            let region = MKCoordinateRegion(
                center: pin.coordinate,
                latitudinalMeters: 10000,
                longitudinalMeters: 10000
            )
            mapRegion = region
        }
        return mapRegion
    }
    
    func loadAnnotationData(
        with mapView: MKMapView,
        and annotation: MKAnnotation
    ) -> (MKMarkerAnnotationView?
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
        return annotationView
    }
}
