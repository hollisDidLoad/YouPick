//
//  AppStoreViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/26/22.
//

import Foundation
import StoreKit

class AppStoreViewController: SKStoreProductViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: NSNumber(value: 284910350)])
    }
}
