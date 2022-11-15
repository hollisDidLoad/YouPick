//
//  NoInternetConnectionView.swift
//  YouPick
//
//  Created by Hollis Kwan on 11/14/22.
//

import Foundation
import UIKit

class NoInternetConnectionView: UIView {
    
    let wifiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "wifi")
        return imageView
    }()
    
    let noWifiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textAlignment = .center
        label.text = "No Internet Connection"
        return label
    }()
    
    let retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Retry", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        addSubview(wifiImageView)
        addSubview(noWifiLabel)
        addSubview(retryButton)
        
        wifiImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        wifiImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50).isActive = true
        wifiImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        wifiImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        noWifiLabel.topAnchor.constraint(equalTo: wifiImageView.bottomAnchor, constant: -20).isActive = true
        noWifiLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        noWifiLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        noWifiLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        retryButton.topAnchor.constraint(equalTo: noWifiLabel.bottomAnchor, constant: -20).isActive = true
        retryButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        retryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        retryButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
