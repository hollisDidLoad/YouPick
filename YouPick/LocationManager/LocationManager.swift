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
 
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    private override init() {}
     
    private var setCurrentLocationCompletion: ((CLLocation) -> Void)?
    let locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    var currentLocation = CLLocation()
    var locationName = String()
    
    func fetchCurrentLocation(completion: @escaping () -> Void) {
        self.setCurrentLocation { [weak self] currentLocation in
            self?.fetchGeoLocation(with: currentLocation, completion: { [weak self] locationName in
                guard let locationName = locationName else { return }
                self?.locationName = locationName
                completion()
            })
        }
    }
    
    private func setCurrentLocation(_ completion: @escaping (CLLocation) -> Void) {
        setCurrentLocationCompletion = completion
        authorizationSetUp()
    }
    
    func requestUserAuthorization() {
        authorizationSetUp()
    }
    
    private func authorizationSetUp() {
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

extension LocationManager {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            delegate?.didUpdateStatus(false)
            UserDefaults.standard.ifLocationEnabled = false
        case .authorizedAlways, .authorizedWhenInUse:
            delegate?.didUpdateStatus(true)
            UserDefaults.standard.ifLocationEnabled = true
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            UserDefaults.standard.ifLocationEnabled = false
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
