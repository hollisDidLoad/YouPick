//
//  MapView.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit
import MapKit

class MapView: UIView {
    
    let currentLocationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let buttonImage = UIImage(systemName: "location.magnifyingglass", withConfiguration: largeConfig)
        button.setImage(buttonImage, for: .normal)
        return button
    }()
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(mapView)
        addSubview(currentLocationButton)
        
        currentLocationButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -40).isActive = true
        currentLocationButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20).isActive = true
        currentLocationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        currentLocationButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
    }
}
