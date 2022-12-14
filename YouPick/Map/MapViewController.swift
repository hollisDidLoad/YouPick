//
//  MapViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController {
    
    private let contentView = MapView(
        locationManager: LocationManager.shared
    )
    private let viewModel = MapViewModel(
        modelController: RestaurantsModelController.shared,
        savedRestaurantsModelController: SavedRestaurantsModelController.shared
    )
    private var locationManager: LocationManager
    private var coreDataController: CoreDataModelController
    private let internetManager: InternetManager
    
    init(
        locationManager: LocationManager,
        coreDataController: CoreDataModelController,
        internetManager: InternetManager
    ) {
        self.locationManager = locationManager
        self.coreDataController = coreDataController
        self.internetManager = internetManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        contentView.currentLocationButton.addTarget(
            self,
            action: #selector(currentLocationButtonTapped),
            for: .touchUpInside
        )
        contentView.mapView.delegate = self
    }
    
    @objc
    private func currentLocationButtonTapped() {
        zoomToCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let pinsData = viewModel.setUpRestaurantPinsData(with: contentView.mapView) else { return }
        contentView.setUpRestaurantPins(with: pinsData)
        contentView.showAllRestaurantPins()
        contentView.setUpCurrentLocationPin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        contentView.clearPins()
    }
}

extension MapViewController {
    
    private func zoomToCurrentLocation() {
        let currentLocation = locationManager.currentLocation
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
        
        contentView.mapView.setRegion(region, animated: true)
    }
    
    private func setUpWebPage(
        with name: String?,
        and mapPinsModel: [MapPinsModel],
        completion: @escaping (UIViewController) -> Void
    ) {
        let authorizedTracking = UserDefaults.standard.ifAuthorizedTracking
        if internetManager.isConnected {
            let webVC = WebPageViewController(
                coreDataController: CoreDataModelController.shared,
                locationManager: LocationManager.shared,
                savedRestaurantsModelController: SavedRestaurantsModelController.shared
            )
            viewModel.setUpWebData(with: name, and: mapPinsModel, completion: { model, url in
                if authorizedTracking {
                    webVC.setUpSavedRestaurantData(with: model)
                    webVC.setUpUrl(with: url)
                    completion(webVC)
                } else {
                    let safariVC = SFSafariViewController(url: url)
                    self.present(safariVC, animated: true)
                }
            })
        } else {
            let noInternetVC = NoInternetConnectionViewController(
                internetManager: InternetManager.shared
            )
            present(noInternetVC, animated: true)
        }
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
        self.setUpWebPage(with: title, and: viewModel.mapPinsModel ,completion: { [weak self] webVC in
            self?.present(webVC, animated: true)
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotationData = viewModel.loadAnnotationData(with: mapView, and: annotation) else { return nil }
        return contentView.loadAnnotationView(with: annotation, and: annotationData)
    }
}
