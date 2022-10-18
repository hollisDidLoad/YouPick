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
    var url: URL?
    var coordinates: Coordinates?
}

struct Coordinates: Codable {
    var longitude: Double?
    var latitude: Double?
}
