//
//  SpinWheel+WheelConfigurations.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit
import SwiftFortuneWheel

extension SFWConfiguration {
    
    static var wheelConfiguration: SFWConfiguration {
        let spin = SFWConfiguration.SpinButtonPreferences(size: CGSize(width: 64, height: 64))
        let sliceColorType = SFWConfiguration.ColorType.customPatternColors(colors: nil, defaultColor: .white)
        let slicePreferences = SFWConfiguration.SlicePreferences(
            backgroundColorType: sliceColorType,
            strokeWidth: 0,
            strokeColor: .white
        )
        let circlePreferences = SFWConfiguration.CirclePreferences(
            strokeWidth: 1,
            strokeColor: UIColor.init(
                red: 32/255,
                green: 93/255,
                blue: 97/255,
                alpha: 1
            ))
        let wheelPreferences = SFWConfiguration.WheelPreferences(
            circlePreferences: circlePreferences,
            slicePreferences: slicePreferences,
            startPosition: .right
        )
        let configuration = SFWConfiguration(wheelPreferences: wheelPreferences, spinButtonPreferences: spin)
        
        return configuration
    }
}

extension TextPreferences {
    static func wheelTextConfiguration(textColor: UIColor) -> TextPreferences {
        let textColorType = SFWConfiguration.ColorType.customPatternColors(colors: nil, defaultColor: textColor)
        var font = UIFont.systemFont(ofSize: 9, weight: .semibold)
        var horizontalOffset: CGFloat = 0
        if let customFont = UIFont(name: "DINCondensed-Bold", size: 12) {
            font = customFont
            horizontalOffset = -2
        }
        var textPreferences = TextPreferences(
            textColorType: textColorType,
            font: font,
            verticalOffset: 5
        )
        textPreferences.horizontalOffset = horizontalOffset
        textPreferences.orientation = .vertical
        textPreferences.alignment = .left
        textPreferences.numberOfLines = 0
        
        return textPreferences
    }
}
