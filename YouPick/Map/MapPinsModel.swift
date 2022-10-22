//
//  MapPinsModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/22/22.
//

import Foundation

struct MapPinsModel {
    let name: String?
    let longitude: Double?
    let latitude: Double?
    let url: URL?
    
    init(_ domainModel: RestaurantsDomainModel) {
        self.name = domainModel.name
        self.longitude = domainModel.longitude
        self.latitude = domainModel.latitude
        self.url = domainModel.url
    }
}
