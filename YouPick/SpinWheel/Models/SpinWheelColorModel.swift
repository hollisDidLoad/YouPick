//
//  SpinWheelColorManager.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/17/22.
//

import Foundation
import UIKit

struct SpinWheelColorModel {
    static let shared = SpinWheelColorModel()
    
    let backgroundColors: [UIColor] =
    [
        .systemOrange,
        .systemBlue,
        .systemRed,
        .systemTeal,
        .systemPink,
        .systemGreen,
        .systemPurple,
        .systemIndigo,
        .systemRed,
        .systemMint
    ]
    
    let textColors: [UIColor] =
    [
        .black,
        .white,
        .black,
        .black,
        .black,
        .white,
        .white,
        .white,
        .black,
        .white
    ]
}
