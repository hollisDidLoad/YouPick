//
//  SavedLocationsDomainModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 11/1/22.
//

import Foundation

struct SavedLocationsDomainModel {
    var name: String?
    var url: URL?
    var location: String?
    
    init(_ spinWheelModel: SpinWheelDataModel) {
        self.name = spinWheelModel.name
        self.url = spinWheelModel.url
        self.location = spinWheelModel.location
    }
    
    init(_ mapPinsModel: MapPinsModel) {
        self.name = mapPinsModel.name
        self.url = mapPinsModel.url
        self.location = mapPinsModel.location
    }
}
