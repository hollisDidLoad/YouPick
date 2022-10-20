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
        LocationManagerViewController.shared.requestCurrentLocation {
            [weak self] in
            self?.locationName = LocationManagerViewController.shared.locationName
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
                completion: { fetchResult in
                    switch fetchResult {
                    case .success(let restaurantAPI):
                        completion(restaurantAPI)
                    case .failure(_):
                        break
                    }
                })
        }
}
