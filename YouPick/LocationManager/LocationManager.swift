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
    private let locationManager = CLLocationManager()
    private var setCurrentLocationCompletion: ((CLLocation) -> Void)?
    var delegate: LocationManagerDelegate?
    var currentLocation = CLLocation()
    var location = String()

    func fetchCurrentLocation(completion: @escaping () -> Void) {
        self.requestCurrentLocation { [weak self] currentLocation in
            self?.fetchGeoLocation(with: currentLocation, completion: { [weak self] locationName in
                guard let location = locationName else { return }
                self?.location = location
                completion()
            })
        }
    }
    
    func requestCurrentLocation(_ completion: @escaping (CLLocation) -> Void) {
        setCurrentLocationCompletion = completion
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    private func fetchGeoLocation(with location: CLLocation, completion: @escaping (String?) -> Void) {
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
        setCurrentLocationCompletion?(self.currentLocation)
        manager.stopUpdatingLocation()
    }
}