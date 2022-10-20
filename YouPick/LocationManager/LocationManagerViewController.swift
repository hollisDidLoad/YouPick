//
//  LocationsManager.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/16/22.
//

import Foundation
import CoreLocation
import UIKit

class LocationsManagerViewController: UIViewController {
    
    static let shared = LocationsManagerViewController()
    
    let viewModel = LocationsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        requestCurrentLocation { [weak self] in
            self?.viewModel.presentTabBarVC(completion: { tabBarVC in
                self?.present(tabBarVC, animated: true)
            })
        }
    }
    
    func requestCurrentLocation(completion: @escaping () -> Void) {
        self.fetchCurrentLocation(completion: { [weak self] currentLocation in
            self?.viewModel.fetchLocation(
                with: currentLocation,
                completion: { [weak self] currentLocation in
                    guard let currentLocation = currentLocation else { return }
                    self?.viewModel.locationName = currentLocation
                    completion()
                })
        })
    }
    
    func fetchCurrentLocation(completion: @escaping (CLLocation) -> Void) {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.viewModel.locationCompletion = completion
                self.viewModel.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.viewModel.locationManager.requestWhenInUseAuthorization()
                self.viewModel.locationManager.delegate = self
                self.viewModel.locationManager.startUpdatingLocation()
            }
        }
    }
}

extension LocationsManagerViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.viewModel.currentLocation = location
        viewModel.locationCompletion?(self.viewModel.currentLocation)
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
