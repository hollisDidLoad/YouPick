//
//  Location+UserDefaults.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/26/22.
//

import Foundation

extension UserDefaults {
    private enum UserDefaultKeys: String {
        case ifLocationEnabled
    }
    
    var ifLocationEnabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.ifLocationEnabled.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.ifLocationEnabled.rawValue)
        }
    }
}
