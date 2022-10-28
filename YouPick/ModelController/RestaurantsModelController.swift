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
    
    var domainModels = [RestaurantsDomainModel]()
    
    func setUpModelData(with restaurantModel: [RestaurantModel]) {
        var modelData = [RestaurantsDomainModel]()
        
        let wheelBackgroundColors = SpinWheelColorModel.backgroundColors
        let wheelTextColors = SpinWheelColorModel.textColors
        
        for (index, restaurantAPIData) in restaurantModel.enumerated() {
            let data = RestaurantsDomainModel(
                restaurantAPIData,
                backgroundColor: wheelBackgroundColors[index],
                textColor: wheelTextColors[index]
            )
            modelData.append(data)
        }
        self.domainModels = modelData
    }
}
