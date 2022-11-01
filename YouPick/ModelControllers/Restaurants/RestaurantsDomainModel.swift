//
//  RestaurantsDomainModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit

struct RestaurantsDomainModel {
    let name: String?
    let url: URL?
    let backgroundColor: UIColor?
    let textColor: UIColor?
    let longitude: Double?
    let latitude: Double?
    let location: String?
    
    init(_ restaurantModel: RestaurantModel, backgroundColor: UIColor?, textColor: UIColor?) {
        self.name = restaurantModel.name
        self.url = restaurantModel.url
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.longitude = restaurantModel.coordinates?.longitude
        self.latitude = restaurantModel.coordinates?.latitude
        self.location = restaurantModel.location?.city
    }
}
