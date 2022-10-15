//
//  RestaurantsAPIModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation

struct RestaurantsAPIModel: Codable {
    enum CodingKeys: String, CodingKey {
        case restaurants = "businesses"
    }
    var restaurants: [RestaurantModel]
}

struct RestaurantModel: Codable {
    var name: String?
    var image_url: URL?
    var rating: Double?
    var location: LocationModel?
}

struct LocationModel: Codable {
    let city: String?
    let state: String?
}
