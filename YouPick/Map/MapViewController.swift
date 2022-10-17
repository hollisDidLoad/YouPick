//
//  MapViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
    
    let contentView = MapView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCurrentLocation()
    }
    
    func setupCurrentLocation() {
        LocationManager.shared.getCurrentLocation(completion: { [weak self] location in
            DispatchQueue.main.async {
                let pin = MKPointAnnotation()
                pin.coordinate = location.coordinate
                self?.contentView.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
                self?.contentView.mapView.addAnnotation(pin)
            }
        })
    }
}
