//
//  SpinWheelModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit

struct SpinWheelModel {
    var name: String?
    var image: UIImage?
    var url: URL?
    var rating: Double?
    
    init(_ domainModel: RestaurantsDomainModel) {
        self.name = domainModel.name
        self.image = nil
        self.url = domainModel.url
        self.rating = domainModel.rating
    }
}
