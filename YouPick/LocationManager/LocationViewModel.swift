//
//  LocationsViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/19/22.
//

import Foundation
import CoreLocation
import UIKit

class LocationViewModel {
    
    let locationManager = CLLocationManager()
    var setCurrentLocation: ((CLLocation) -> Void)?
    
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
    
    func presentTabBarVC(completion: @escaping (UIViewController) -> Void) {
        let tabBarVC = TabBarViewController()
        tabBarVC.modalPresentationStyle = .fullScreen
        completion(tabBarVC)
    }
}
