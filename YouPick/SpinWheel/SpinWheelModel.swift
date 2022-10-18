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
    var url: URL?
    var color: UIColor?
    var textColor: UIColor?
    
    init(_ domainModel: RestaurantsDomainModel) {
        self.name = domainModel.name
        self.url = domainModel.url
        self.color = domainModel.color
        self.textColor = domainModel.textColor
    }
}
