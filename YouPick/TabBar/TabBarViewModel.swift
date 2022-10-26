//
//  TabBarViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/18/22.
//

import Foundation

class TabBarViewModel {
    
    private var currentLocation = String()
    
    func fetchCurrentLocation(completion: @escaping () -> Void) {
        LocationManager.shared.fetchCurrentLocation { [weak self] in
            self?.currentLocation = LocationManager.shared.locationName
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func fetchAPIData(completion: @escaping () -> Void) {
        NetworkManager.shared.fetchRestaurantsAPI(
            limit: "10",
            location: self.currentLocation,
            completion: { fetchResult in
                switch fetchResult {
                case .success(let restaurantAPI):
                    RestaurantsModelController.shared.setUpModelData(with: restaurantAPI)
                    completion()
                case .failure(_):
                    break
                }
            })
    }
}
