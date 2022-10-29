//
//  SpinWheelViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/17/22.
// 

import Foundation

class SpinWheelViewModel {
    
    private var networkManager: NetworkManager
    private var modelControleller: RestaurantsModelController
    func spinIndex(count: Int) -> Int {
        return Int.random(in: 0..<count)
    }
    
    init(modelController: RestaurantsModelController, networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.modelControleller = modelController
    }
    
    
    func fetchRestaurants(
        businessLimit: String = "10",
        with searchResult: String,
        completion: @escaping (Result<[SpinWheelDataModel], Error>) -> Void,
        errorCompletion: @escaping () -> Void
    ) {
        networkManager.fetchRestaurantsAPI(
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
    
    private func updateSpinWheel(with restaurantAPI: [RestaurantModel], completion: @escaping ([SpinWheelDataModel]) -> Void) {
        modelControleller.domainModels.removeAll()
        modelControleller.setUpModelData(with: restaurantAPI)
        let domainModels = modelControleller.domainModels
        let spinWheelModel = domainModels.map { SpinWheelDataModel($0) }
        completion(spinWheelModel)
    }
}
