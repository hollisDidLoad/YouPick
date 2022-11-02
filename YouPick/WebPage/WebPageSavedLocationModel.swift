//
//  WebPageSavedLocationModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 11/1/22.
//

import Foundation

struct WebPageSavedLocationModel {
    var name: String?
    var url: URL?
    var location: String?
    
    init(data: SavedLocationDomainModel) {
        self.name = data.name
        self.url = data.url
        self.location = data.location
    }
}
