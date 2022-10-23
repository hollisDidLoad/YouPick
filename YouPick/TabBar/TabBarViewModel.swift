//
//  TabBarViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/18/22.
//

import Foundation
import UIKit

class TabBarViewModel {
    
    private var locationName = String()
    
    func fetchCurrentLocation(completion: @escaping () -> Void) {
        LocationManagerViewController.shared.fetchCurrentLocation { [weak self] in
            self?.locationName = LocationManagerViewController.shared.locationName
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func fetchBusinesses(
        completion: @escaping () -> Void) {
            NetworkManager.shared.fetchBusinesses(
                limit: "10",
                location: self.locationName,
                completion: { fetchResult in
                    switch fetchResult {
                    case .success(let restaurantAPI):
                        RestaurantsModelController.shared.setUpModelData(
                            with: restaurantAPI)
                            completion()
                    case .failure(_):
                        break
                    }
                })
        }
}
