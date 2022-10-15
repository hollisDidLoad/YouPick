//
//  MapViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit

class MapViewController: UIViewController {
    
    let contentView = MapView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCurrentLocation()
    }
    
    func setupCurrentLocation() {
    }
}
