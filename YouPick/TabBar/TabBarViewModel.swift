//
//  TabBarViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/18/22.
//

import Foundation
import UIKit

class TabBarViewModel {
    
    var locationName = String()
    
    func fetchCurrentLocation(completion: @escaping () -> Void) {
        LocationsManagerViewController.shared.authorizeLocation {
            [weak self] in
            self?.locationName = LocationsManagerViewController.shared.locationName
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func fetchBusinesses(
        with location: String,
        completion: @escaping ([RestaurantModel]) -> Void) {
            NetworkManager.shared.fetchBusinesses(
                limit: "10",
                location: location,
                errorCompletion: {},
                completion: { restaurantAPI in
                    completion(restaurantAPI)
                })
        }
}
