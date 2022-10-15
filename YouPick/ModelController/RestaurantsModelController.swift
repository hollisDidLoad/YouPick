//
//  RestaurantsModelController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation

class RestaurantsModelController {
    
    static let shared = RestaurantsModelController()
    private init() {}
    
    var domainModel = [RestaurantsDomainModel]()
    
}
