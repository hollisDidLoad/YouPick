//
//  SpinWheelViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/17/22.
// 

import Foundation

class SpinWheelViewModel {
    
    func spinIndex(count: Int) -> Int {
        return Int.random(in: 0..<count)
    }
    
    func fetchRestaurantsFromSearchedLocation(
        businessLimit: String = "10",
        with searchResult: String,
        completion: @escaping (Result<[SpinWheelModel], Error>) -> Void,
        errorCompletion: @escaping () -> Void
    ) {
        NetworkManager.shared.fetchRestaurantsAPI(
            limit: businessLimit,
            location: searchResult,
            completion: { [weak self] fetchResult in
                switch fetchResult {
                case .success(let restaurantAPI):
                    if restaurantAPI.count != 0 {
                        self?.updateSpinWheel(with: restaurantAPI, completion: { updatedSpinWheelModel in
                            DispatchQueue.main.async {
                                completion(.success(updatedSpinWheelModel))
                            }
                        })
                    } else {
                        errorCompletion()
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            })
    }
    
    private func updateSpinWheel(with restaurantAPI: [RestaurantModel], completion: @escaping ([SpinWheelModel]) -> Void) {
        RestaurantsModelController.shared.domainModel.removeAll()
        RestaurantsModelController.shared.setUpModelData(with: restaurantAPI)
        let domainModel = RestaurantsModelController.shared.domainModel
        let spinWheelModel = domainModel.map { SpinWheelModel($0) }
        completion(spinWheelModel)
    }
}
