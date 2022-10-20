//
//  LocationManager.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/16/22.
//

import Foundation
import CoreLocation
import UIKit

class LocationManagerViewController: UIViewController, CLLocationManagerDelegate {
    static let shared = LocationManagerViewController()
    
    let manager = CLLocationManager()
    var completion: ((CLLocation) -> Void)?
    var currentLocation = CLLocation()
    var locationName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        authorizeLocation { [weak self] in
            self?.presentTabBarVC()
        }
    }

    func authorizeLocation(completion: @escaping () -> Void) {
        self.getCurrentLocation(completion: { [weak self] location in
            self?.getLocationName(with: location, completion: { [weak self] name in
                guard let name = name else { return }
                self?.locationName = name
                completion()
            })
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.currentLocation = location
        completion?(location)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if manager.authorizationStatus == .denied {
            let alertController = UIAlertController(title: "Location Not Found!\n", message: "Location is required in order to fully use the application and all its functionalities.\n\nPlease enable location access to use the app. Thank you.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss App", style: .cancel, handler: { _ in
                exit(0)
            }))
            present(alertController, animated: true)
        }
    }
    
    func getCurrentLocation(completion: @escaping (CLLocation) -> Void) {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.completion = completion
                self.manager.desiredAccuracy = kCLLocationAccuracyBest
                self.manager.requestWhenInUseAuthorization()
                self.manager.delegate = self
                self.manager.startUpdatingLocation()
            }
        }
    }
    
    func presentTabBarVC() {
        let tabBarVC = TabBarViewController()
        tabBarVC.modalPresentationStyle = .fullScreen
        self.present(tabBarVC, animated: false)
    }
    
    private func getLocationName(with location: CLLocation, completion: @escaping (String?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, preferredLocale: .current) { placeMarks, error in
            if let error = error {
                print(error)
                return
            }
            
            var name = String()
            
            guard let place = placeMarks?.first else { return }
            if let location = place.locality {
                name += location
            }
            completion(name)
        }
    }
}
