//
//  SavedLocationsModelController.swift
//  YouPick
//
//  Created by Hollis Kwan on 11/1/22.
//

import Foundation

class SavedLocationModelController {
    static let shared = SavedLocationModelController()
    private init() {}
    
    var domainModel: SavedLocationDomainModel?
    
    func fetchSpinWheelSavedData(with spinWheelModel: SpinWheelDataModel, completion: @escaping () -> Void) {
        self.domainModel = SavedLocationDomainModel(spinWheelModel)
        completion()
    }
    
    func fetchMapPinSavedData(with mapPinsModel: MapPinsModel) {
        self.domainModel = SavedLocationDomainModel(mapPinsModel)
    }
}
