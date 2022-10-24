//
//  LocationManager.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/16/22.
//

import Foundation
import CoreLocation
import UIKit

protocol LocationManagerDelegate: AnyObject {
    func didUpdateStatus(_ allowed: Bool)
}

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    var locationName = String()
    var currentLocation = CLLocation()
    let locationManager = CLLocationManager()
    var setCurrentLocation: ((CLLocation) -> Void)?
    var delegate: LocationManagerDelegate?

    func fetchCurrentLocation(completion: @escaping () -> Void) {
        self.requestCurrentLocation { [weak self] currentLocation in
            self?.fetchLocation(with: currentLocation, completion: { [weak self] locationName in
                guard let locationName = locationName else { return }
                self?.locationName = locationName
                completion()
            })
        }
    }
    
    func fetchLocation(with location: CLLocation, completion: @escaping (String?) -> Void) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale: .current) { placeMarks, error in
            if let error = error {
                print(error)
                return
            }
            
            var locationName = String()
            
            guard let place = placeMarks?.first else { return }
            if let location = place.locality {
                locationName = location
            }
            
            completion(locationName)
        }
    }
    
    func requestCurrentLocation(_ completion: @escaping (CLLocation) -> Void) {
        self.setCurrentLocation = completion
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
}


//MARK: - Location Manager Delegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            delegate?.didUpdateStatus(false)
        case .authorizedAlways, .authorizedWhenInUse:
            delegate?.didUpdateStatus(true)
        case .notDetermined:
            requestCurrentLocation({_ in})
        @unknown default:
            delegate?.didUpdateStatus(false)
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        self.currentLocation = currentLocation
        setCurrentLocation?(self.currentLocation)
        manager.stopUpdatingLocation()
    }
}
