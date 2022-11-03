//
//  AppTrackingTransparency+UserDefaults.swift
//  YouPick
//
//  Created by Hollis Kwan on 11/3/22.
//

import Foundation

extension UserDefaults {
    private enum UserDefaultKeys: String {
        case ifAuthorizedTracking
    }
    
    var ifAuthorizedTracking: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.ifAuthorizedTracking.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.ifAuthorizedTracking.rawValue)
        }
    }
}
