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
        requestCurrentLocation({ [weak self] _ in
            self?.presentTabBarVC()
        })
    }
    
    func fetchCurrentLocation(completion: @escaping () -> Void) {
            self.requestCurrentLocation { [weak self] currentLocation in
                self?.viewModel.fetchLocation(with: currentLocation, completion: { [weak self] locationName in
                    guard let locationName = locationName else { return }
                    self?.locationName = locationName
                    completion()
                })
        }
    }
    
    private func requestCurrentLocation(_ completion: @escaping (CLLocation) -> Void) {
        DispatchQueue.global().async {
            self.viewModel.setCurrentLocation = completion
            self.viewModel.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.viewModel.locationManager.requestWhenInUseAuthorization()
            self.viewModel.locationManager.delegate = self
            self.viewModel.locationManager.startUpdatingLocation()
        }
    }
}


//MARK: - Location Manager Delegate

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
                title: LocationDeniedModel().buttonTitle,
                style: .cancel,
                handler: { _ in
                    exit(0)
                }))
            present(alertController, animated: true)
        }
    }
    
    func presentTabBarVC() {
        DispatchQueue.main.async {
            let tabBarVC = TabBarViewController()
            tabBarVC.modalPresentationStyle = .fullScreen
            self.present(tabBarVC, animated: false)
        }
    }
}
