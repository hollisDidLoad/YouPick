//
//  SpinWheelViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/17/22.
//

import Foundation
import UIKit

class SpinWheelViewModel {
    
    var maxSearchLimit = "10"
    var domainModel = RestaurantsModelController.shared.domainModel
    
    func fetchBusinesses( 
        limit maxSearch: String,
        with searchResult: String,
        completion: @escaping (Result<[RestaurantModel], Error>) -> Void
    ) {
        NetworkManager.shared.fetchBusinesses(
            limit: maxSearch,
            location: searchResult,
            completion: { fetchResult in
                switch fetchResult {
                case .success(let restaurantAPI):
                    RestaurantsModelController.shared.domainModel.removeAll()
                    RestaurantsModelController.shared.setUpModelData(with: restaurantAPI, completion: {
                        completion(.success(restaurantAPI))
                    })
                case .failure(let error):
                    completion(.failure(error))
                }
            })
    }
    
    func updateSpinWheel(with restaurantAPI: [RestaurantModel], completion: @escaping ([RestaurantsDomainModel]?) -> Void) {
        RestaurantsModelController.shared.setUpModelData(with: restaurantAPI, completion: {
            let domainModel = RestaurantsModelController.shared.domainModel
            DispatchQueue.main.async {
                completion(domainModel)
            }
        })
    }
}
