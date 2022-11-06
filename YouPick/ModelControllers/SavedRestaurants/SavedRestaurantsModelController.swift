//
//  SavedRestaurantsModelController.swift
//  YouPick
//
//  Created by Hollis Kwan on 11/1/22.
//

import Foundation

class SavedRestaurantsModelController {
    static let shared = SavedRestaurantsModelController()
    private init() {}
    
    var domainModel: SavedRestaurantDomainModel?
    
    func fetchSpinWheelSavedData(with spinWheelModel: SpinWheelDataModel, completion: @escaping () -> Void) {
        self.domainModel = SavedRestaurantDomainModel(spinWheelModel)
        completion()
    }
    
    func fetchMapPinSavedData(with mapPinsModel: MapPinsModel) {
        self.domainModel = SavedRestaurantDomainModel(mapPinsModel)
    }
}
