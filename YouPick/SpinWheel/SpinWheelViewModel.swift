//
//  SpinWheelViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/17/22.
// 

import Foundation

class SpinWheelViewModel {
    
    private var networkManager: NetworkManager
    private var modelController: RestaurantsModelController
    private var savedRestaurantsModelController: SavedRestaurantsModelController
    
    
    init(modelController: RestaurantsModelController,
         networkManager: NetworkManager,
         savedRestaurantsModelController: SavedRestaurantsModelController
    ) {
        self.networkManager = networkManager
        self.modelController = modelController
        self.savedRestaurantsModelController = savedRestaurantsModelController
    }
    
    func spinIndex(count: Int) -> Int {
        return Int.random(in: 0..<count)
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
    
    private func updateSpinWheel(
        with restaurantAPI: [RestaurantModel],
        completion: @escaping ([SpinWheelDataModel]) -> Void
    ) {
        modelController.domainModels.removeAll()
        modelController.setUpModelData(with: restaurantAPI)
        let domainModels = modelController.domainModels
        let spinWheelModel = domainModels.map { SpinWheelDataModel($0) }
        completion(spinWheelModel)
    }
    
    func setUpSavedRestaurantsSpinWheelData(
        with spinWheelModel: SpinWheelDataModel,
        completion: @escaping (SavedRestaurantDomainModel) -> Void
    ) {
        self.savedRestaurantsModelController.fetchSpinWheelSavedData(with: spinWheelModel, completion: { [weak self] in
            guard let model = self?.savedRestaurantsModelController.domainModel else { return }
            completion(model)
        })
    }
}
