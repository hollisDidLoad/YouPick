//
//  FailedSearchModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/21/22.
//

import Foundation

struct FailedSearchModel {
    static let title: String = "Oops!"
    static let buttonTitle: String = "Okay"
    
    static func message(_ search: String) -> String {
        " \nUnable to find results for the location: \(search)\n\n Please try a different location!"
    }
}
