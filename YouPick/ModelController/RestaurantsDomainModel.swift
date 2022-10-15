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
    var image: UIImage?
    var url: URL?
    var rating: Double?
    var city : String?
    var state: String?
    
    init(_ restaurantModel: RestaurantModel) {
        self.name = restaurantModel.name
        self.image = nil
        self.url = restaurantModel.image_url
        self.rating = restaurantModel.rating
        self.state = restaurantModel.location?.state
        self.city = restaurantModel.location?.city
    }
}
