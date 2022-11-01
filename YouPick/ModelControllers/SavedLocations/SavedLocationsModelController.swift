//
//  SavedLocationsModelController.swift
//  YouPick
//
//  Created by Hollis Kwan on 11/1/22.
//

import Foundation

class SavedLocationsModelController {
    static let shared = SavedLocationsModelController()
    private init() {}
    
    var domainModel: SavedLocationsDomainModel?
    
    func fetchSpinWheelSavedData(with spinWheelModel: SpinWheelDataModel, completion: @escaping () -> Void) {
        self.domainModel = SavedLocationsDomainModel(spinWheelModel)
        completion()
    }
    
    func fetchMapPinSavedData(with mapPinsModel: MapPinsModel) {
        self.domainModel = SavedLocationsDomainModel(mapPinsModel)
    }
}
