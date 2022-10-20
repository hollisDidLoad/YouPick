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
    
    let locationManager = CLLocationManager()
    var completion: ((CLLocation) -> Void)?
    var currentLocation = CLLocation()
    var locationName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        authorizeLocation { [weak self] in
            self?.viewModel.presentTabBarVC(completion: { tabBarVC in
                self?.present(tabBarVC, animated: true)
            })
        }
    }
    
    func authorizeLocation(completion: @escaping () -> Void) {
        self.getCurrentLocation( completion: { [weak self] currentLocation in
            self?.viewModel.getLocationName(
                with: currentLocation,
                completion: { [weak self] location in
                    guard let location = location else { return }
                    self?.locationName = location
                    completion()
                })
        })
    }
    
    func getCurrentLocation(completion: @escaping (CLLocation) -> Void) {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.completion = completion
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.delegate = self
                self.locationManager.startUpdatingLocation()
            }
        }
    }
}

extension LocationsManagerViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.currentLocation = location
        completion?(location)
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
