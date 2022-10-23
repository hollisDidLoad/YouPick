//
//  SpinWheelViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/17/22.
// 

import Foundation
import UIKit

class SpinWheelViewModel {
    
    private var domainModel = RestaurantsModelController.shared.domainModel
    
    func fetchBusinesses(
        businessLimit: String = "10",
        with searchResult: String,
        completion: @escaping (Result<[RestaurantModel], Error>) -> Void
    ) {
        NetworkManager.shared.fetchBusinesses(
            limit: businessLimit,
            location: searchResult,
            completion: { fetchResult in
                switch fetchResult {
                case .success(let restaurantAPI):
                    RestaurantsModelController.shared.domainModel.removeAll()
                    RestaurantsModelController.shared.setUpModelData(
                        with: restaurantAPI)
                    DispatchQueue.main.async {
                        completion(.success(restaurantAPI))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            })
    }
    
    func updateSpinWheel(with restaurantAPI: [RestaurantModel], completion: @escaping ([RestaurantsDomainModel]) -> Void) {
        RestaurantsModelController.shared.setUpModelData(with: restaurantAPI)
            let domainModel = RestaurantsModelController.shared.domainModel
            DispatchQueue.main.async {
                completion(domainModel)
            }
    }
}
