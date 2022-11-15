//
//  AppDelegate.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import UIKit
 
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        InternetManager.shared.startMonitoring()
        return true
    }
}
