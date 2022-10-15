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
    let image: UIImage?
    var url: URL?
    let rating: Double?
    let city : String?
    let state: String?
    
    init(_ restaurantModel: RestaurantModel) {
        self.name = restaurantModel.name
        self.image = nil
        self.url = restaurantModel.image_url
        self.rating = restaurantModel.rating
        self.state = restaurantModel.location?.state
        self.city = restaurantModel.location?.city
    }
}
