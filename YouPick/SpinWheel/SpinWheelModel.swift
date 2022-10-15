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
    var color: UIColor?
    var textColor: UIColor
    
    init(name: String, color: UIColor, textColor: UIColor) {
        self.name = name
        self.color = color
        self.textColor = textColor
    }
}
