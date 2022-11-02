//
//  TabBarViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/18/22.
//

import Foundation

class TabBarViewModel {

    private var limitCount: Int = 10
    private var currentLocation = String()
    private var locationManager: LocationManager
    private var networkManager: NetworkManager
    private var modelController: RestaurantsModelController
    
    init(
        modelController: RestaurantsModelController,
        locationManager: LocationManager,
        networkManager: NetworkManager
    ) {
        self.modelController = modelController
        self.locationManager = locationManager
        self.networkManager = networkManager
    }
    
    func fetchCurrentLocation(completion: @escaping () -> Void) {
        locationManager.fetchCurrentLocation { [weak self] in
            guard let currentLocation = self?.locationManager.locationName else { return }
            self?.currentLocation = currentLocation
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func fetchAPIData(completion: @escaping () -> Void) {
        networkManager.fetchRestaurantsAPI(
            limit: "\(limitCount)",
            location: self.currentLocation,
            completion: { [weak self] fetchResult in
                switch fetchResult {
                case .success(let restaurantAPI):
                    self?.modelController.setUpModelData(with: restaurantAPI)
                    completion()
                case .failure(_):
                    break
                }
            })
    }
}
