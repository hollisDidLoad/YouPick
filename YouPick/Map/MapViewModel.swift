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
    private let savedLocationModelController: SavedLocationModelController
    
    init(modelController: RestaurantsModelController, savedLocationModelController: SavedLocationModelController) {
        self.modelController = modelController
        self.savedLocationModelController = savedLocationModelController
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
    
    func setUpWebData(
        with name: String?,
        and mapPinsModel: [MapPinsModel],
        completion: @escaping (SavedLocationDomainModel, URL) -> Void
    ) {
        guard let index = mapPinsModel.firstIndex(where: { $0.name == name }),
              let url = mapPinsModel[index].url
        else { return }
        
        self.savedLocationModelController.fetchMapPinSavedData(with: mapPinsModel[index])
        if let model = self.savedLocationModelController.domainModel {
            completion(model, url)
        }
    }
}
