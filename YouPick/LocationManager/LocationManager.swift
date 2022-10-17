//
//  LocationManager.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/16/22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        completion?(location)
        manager.stopUpdatingLocation()
    }
    
    func getCurrentLocation(completion: @escaping (CLLocation) -> Void) {
        self.completion = completion
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
