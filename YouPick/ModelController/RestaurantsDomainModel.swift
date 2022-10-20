//
//  RestaurantsDomainModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit

struct RestaurantsDomainModel {
    var name: String?
    var url: URL?
    var backgroundColor: UIColor?
    var textColor: UIColor?
    var longitude: Double?
    var latitude: Double?
    var restaurantModel: RestaurantModel?
    
    init(_ restaurantModel: RestaurantModel, backgroundColor: UIColor?, textColor: UIColor?) {
        self.name = restaurantModel.name
        self.url = restaurantModel.url
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.longitude = restaurantModel.coordinates?.longitude
        self.latitude = restaurantModel.coordinates?.latitude
    }
}
