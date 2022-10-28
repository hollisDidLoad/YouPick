//
//  SpinWheelModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit

struct SpinWheelDataModel {
    var name: String?
    var url: URL?
    var backgroundColor: UIColor?
    var textColor: UIColor?
    
    init(_ domainModel: RestaurantsDomainModel) {
        self.name = domainModel.name
        self.url = domainModel.url
        self.backgroundColor = domainModel.backgroundColor
        self.textColor = domainModel.textColor
    }
}
