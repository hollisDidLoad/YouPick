//
//  RestaurantsModelController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation

class RestaurantsModelController {
    
    static let shared = RestaurantsModelController()
    private init() {}
    
    var domainModel = [RestaurantsDomainModel]()
    
    func setupModelData(with APIModel: [RestaurantModel], completion: @escaping () -> Void) {
        
        var domainModel = [RestaurantsDomainModel]()
        
        let backgroundColors = SpinWheelColorModel.shared.backgroundColors
        let textColors = SpinWheelColorModel.shared.textColors
        
        for (index, apiModel) in APIModel.enumerated() {
            let model = RestaurantsDomainModel(
                apiModel,
                backgroundColor: backgroundColors[index],
                textColor: textColors[index])
            domainModel.append(model)
        }
        RestaurantsModelController.shared.domainModel = domainModel
        DispatchQueue.main.async {
            completion()
        }
    }
}
