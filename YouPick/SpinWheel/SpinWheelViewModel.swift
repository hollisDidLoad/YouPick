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
    private var savedLocationModelController: SavedLocationModelController
    func spinIndex(count: Int) -> Int {
        return Int.random(in: 0..<count)
    }
    
    init(modelController: RestaurantsModelController, networkManager: NetworkManager, savedLocationModelController: SavedLocationModelController) {
        self.networkManager = networkManager
        self.modelControleller = modelController
        self.savedLocationModelController = savedLocationModelController
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
    
    func setUpSavedLocationSpinWheelData(with spinWheelModel: SpinWheelDataModel, completion: @escaping (SavedLocationDomainModel) -> Void) {
        self.savedLocationModelController.fetchSpinWheelSavedData(with: spinWheelModel, completion: { [weak self] in
            guard let model = self?.savedLocationModelController.domainModel else { return }
            completion(model)
        })
    }
}
