//
//  RequestLocationDeniedModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/20/22.
//

import Foundation

struct RequestLocationDeniedModel {
    // TODO: - Make these static let so you don't have to initialize `RequestLocationDeniedModel` to use these
    let title: String = "Location Not Found!\n"
    let message: String = "Location is required in order to fully use the application and all its functionalities.\n\nPlease enable location access to use the app. Thank you."
    let buttonTitle: String = "Enable Location"
}
