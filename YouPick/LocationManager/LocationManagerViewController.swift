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
        view.backgroundColor = .systemOrange
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func setUpLocation(completion: @escaping () -> Void) {
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
    }

    func getCurrentLocation(completion: @escaping (CLLocation) -> Void) {
        self.completion = completion
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }

    func getLocationName(with location: CLLocation, completion: @escaping (String?) -> Void) {
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
