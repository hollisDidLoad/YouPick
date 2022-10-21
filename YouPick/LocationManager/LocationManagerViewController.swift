//
//  LocationManager.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/16/22.
//

import Foundation
import CoreLocation
import UIKit

class LocationManagerViewController: UIViewController {
    
    static let shared = LocationManagerViewController()
    
    private let viewModel = LocationViewModel()
    
    var currentLocation = CLLocation()
    var locationName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        requestCurrentLocation { [weak self] in
            let tabBarVC = TabBarViewController()
            tabBarVC.modalPresentationStyle = .fullScreen
            self?.present(tabBarVC, animated: false)
        }
    }

    func requestCurrentLocation(completion: @escaping () -> Void) {
        self.fetchCurrentLocation(locationCompletion: { [weak self] currentLocation in
            self?.viewModel.fetchLocation(
                with: currentLocation,
                completion: { [weak self] locationName in
                    guard let locationName = locationName else { return }
                    self?.locationName = locationName
                    completion()
                })
        })
    }
    
    func fetchCurrentLocation(locationCompletion: @escaping (CLLocation) -> Void) {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.viewModel.setCurrentLocation = locationCompletion
                self.viewModel.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.viewModel.locationManager.requestWhenInUseAuthorization()
                self.viewModel.locationManager.delegate = self
                self.viewModel.locationManager.startUpdatingLocation()
            }
        }
    }
}

extension LocationManagerViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        self.currentLocation = currentLocation
        viewModel.setCurrentLocation?(self.currentLocation)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if manager.authorizationStatus == .denied {
            let alertController = UIAlertController(
                title: LocationDeniedModel().title,
                message: LocationDeniedModel().message,
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(
                title: LocationDeniedModel().actionTitle,
                style: .cancel,
                handler: { _ in
                    exit(0)
                }))
            present(alertController, animated: true)
        }
    }
}
