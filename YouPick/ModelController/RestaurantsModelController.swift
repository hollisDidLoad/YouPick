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
    let colorModel = SpinWheelColorModel()

    func setUpModelData(with restaurantAPI: [RestaurantModel]) {
        var modelData = [RestaurantsDomainModel]()
        
        let wheelBackgroundColors = colorModel.backgroundColors
        let wheelTextColors = colorModel.textColors
        
        for (index, restaurantAPIData) in restaurantAPI.enumerated() {
            let data = RestaurantsDomainModel(
                restaurantAPIData,
                backgroundColor: wheelBackgroundColors[index],
                textColor: wheelTextColors[index]
            )
            modelData.append(data)
        }
        self.domainModel = modelData
    }
}
