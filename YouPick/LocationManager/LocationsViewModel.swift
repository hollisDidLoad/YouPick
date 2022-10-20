//
//  LocationsViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/19/22.
//

import Foundation
import CoreLocation
import UIKit

class LocationsViewModel {
    
    let locationManager = CLLocationManager()
    var locationCompletion: ((CLLocation) -> Void)?
    
    func getLocationName(with location: CLLocation, completion: @escaping (String?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, preferredLocale: .current) { placeMarks, error in
            if let error = error {
                print(error)
                return
            }
            
            var location = String()
            
            guard let place = placeMarks?.first else { return }
            if let locationName = place.locality {
                location += locationName
            }
            completion(location)
        }
    }
    func presentTabBarVC(completion: @escaping (UIViewController) -> Void) {
        let tabBarVC = TabBarViewController()
        tabBarVC.modalPresentationStyle = .fullScreen
        completion(tabBarVC)
    }
}
