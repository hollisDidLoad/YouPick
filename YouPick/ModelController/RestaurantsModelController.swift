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
        
        var modelData = [RestaurantsDomainModel]()
        
        let wheelBackgroundColors = SpinWheelColorModel.shared.backgroundColors
        let wheelTextColors = SpinWheelColorModel.shared.textColors
        
        for (index, model) in APIModel.enumerated() {
            let data = RestaurantsDomainModel(model,
                backgroundColor: wheelBackgroundColors[index],
                textColor: wheelTextColors[index])
            modelData.append(data)
        }
        
        RestaurantsModelController.shared.domainModel = modelData
        DispatchQueue.main.async {
            completion()
        }
    }
}
