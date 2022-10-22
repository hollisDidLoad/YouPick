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
    
    func setUpModelData(with restaurantModel: [RestaurantModel]) {
        var modelData = [RestaurantsDomainModel]()
        
        let wheelBackgroundColors = SpinWheelColorModel.shared.backgroundColors
        let wheelTextColors = SpinWheelColorModel.shared.textColors
        
        for (index, restaurantModelData) in restaurantModel.enumerated() {
            let data = RestaurantsDomainModel(
                restaurantModelData,
                backgroundColor: wheelBackgroundColors[index],
                textColor: wheelTextColors[index]
            )
            modelData.append(data)
        }
        self.domainModel = modelData
    }
}
