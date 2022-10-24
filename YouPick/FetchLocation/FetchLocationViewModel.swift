//
//  FetchLocationViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/23/22.
//

import Foundation
import UIKit

class FetchLocationViewModel {
    
    private var locationName = String()
    
    func fetchCurrentLocation(completion: @escaping () -> Void) {
        LocationManager.shared.fetchCurrentLocation { [weak self] in
            self?.locationName = LocationManager.shared.locationName
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func fetchBusinesses() {
            NetworkManager.shared.fetchBusinesses(
                limit: "10",
                location: self.locationName,
                completion: { fetchResult in
                    switch fetchResult {
                    case .success(let restaurantAPI):
                        RestaurantsModelController.shared.setUpModelData(with: restaurantAPI)
                    case .failure(_):
                        break
                    }
                })
        }
}
