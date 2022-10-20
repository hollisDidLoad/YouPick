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
    
    func setUpModelData(with APIModel: [RestaurantModel], completion: @escaping () -> Void) {
        
        var modelData = self.domainModel
        let backgroundColors = SpinWheelColorModel.shared.backgroundColors
        let textColors = SpinWheelColorModel.shared.textColors
        
        for (index, model) in APIModel.enumerated() {
            let model = RestaurantsDomainModel(model,
                backgroundColor: backgroundColors[index],
                textColor: textColors[index])
            modelData.append(model)
        }
        RestaurantsModelController.shared.domainModel = modelData
        DispatchQueue.main.async {
            completion()
        }
    }
}
