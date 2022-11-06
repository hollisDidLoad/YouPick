//
//  WebPageSavedRestaurantsModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 11/1/22.
//

import Foundation

struct WebPageSavedRestaurantsModel {
    var name: String?
    var url: URL?
    var location: String?
    
    init(data: SavedRestaurantDomainModel) {
        self.name = data.name
        self.url = data.url
        self.location = data.location
    }
}
