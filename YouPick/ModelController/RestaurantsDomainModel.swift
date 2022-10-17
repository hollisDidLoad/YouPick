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
    var color: UIColor?
    var textColor: UIColor?
    var restaurantModel: RestaurantModel?
    
    init(_ restaurantModel: RestaurantModel, backgroundColor: UIColor?, textColor: UIColor?) {
        self.name = restaurantModel.name
        self.image = nil
        self.url = restaurantModel.image_url
        self.rating = restaurantModel.rating
        self.color = backgroundColor
        self.textColor = textColor
    }
    
    init(_ restaurantModel: RestaurantModel) {
        self.restaurantModel = restaurantModel
    }
}
