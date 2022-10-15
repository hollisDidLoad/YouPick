//
//  SpinWheelVew.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit
import SwiftFortuneWheel

class SpinWheelView: UIView {
    
    var slices = [Slice]()
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.placeholder = "Search Location Here..."
        return bar
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 0.4
        button.layer.borderColor = UIColor.systemGray4.cgColor
        return button
    }()
    
    let spinnerFrameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "circleGradient")
        return imageView
    }()
    
    let centerCircleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "darkBlueCenterImage")
        return imageView
    }()
    
    let pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "darkBlueRightPinImage")
        return imageView
    }()
    
    let standImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "bottomImage")
        return imageView
    }()
    
    let spinButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SPIN", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 20
        return button
    }()

    func setupSlices() {
        let domainModel = RestaurantsModelController.shared.domainModel
        var spinWheelModel = [SpinWheelViewModel]()
        for model in domainModel {
            guard let name = model.name, let backgroundColor = model.color, let textColor = model.textColor else { return }
            let spinWheel = SpinWheelViewModel(name: name, color: backgroundColor, textColor: textColor)
            spinWheelModel.append(spinWheel)
        }
        
        for model in spinWheelModel {
            guard let name = model.name else { return }
            let sliceContent = [Slice.ContentType.text(text: name, preferences: .wheelTextConfiguration(textColor: model.textColor))]
            let sliceSetup = Slice(contents: sliceContent, backgroundColor: model.color)
            slices.append(sliceSetup)
        }
    }
    
    lazy var spinWheel: SwiftFortuneWheel = {
        setupSlices()
        let spinWheel = SwiftFortuneWheel(frame: .zero, slices: slices, configuration: .wheelConfiguration)
        return spinWheel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        addSubview(standImageView)
        addSubview(spinWheel)
        addSubview(spinnerFrameImageView)
        addSubview(pinImageView)
        addSubview(centerCircleImageView)
        addSubview(spinButton)
        
        spinWheel.translatesAutoresizingMaskIntoConstraints = false
        spinWheel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        spinWheel.heightAnchor.constraint(equalToConstant: 300).isActive = true
        spinWheel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinWheel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor,constant: 150).isActive = true
        
        spinnerFrameImageView.topAnchor.constraint(equalTo: spinWheel.topAnchor).isActive = true
        spinnerFrameImageView.leadingAnchor.constraint(equalTo: spinWheel.leadingAnchor).isActive = true
        spinnerFrameImageView.trailingAnchor.constraint(equalTo: spinWheel.trailingAnchor).isActive = true
        spinnerFrameImageView.bottomAnchor.constraint(equalTo: spinWheel.bottomAnchor).isActive = true
        
        pinImageView.leadingAnchor.constraint(equalTo: spinnerFrameImageView.trailingAnchor,constant: -45).isActive = true
        pinImageView.topAnchor.constraint(equalTo: spinWheel.topAnchor,constant: 123).isActive = true
        pinImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pinImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        centerCircleImageView.centerXAnchor.constraint(equalTo: spinnerFrameImageView.centerXAnchor).isActive = true
        centerCircleImageView.centerYAnchor.constraint(equalTo: spinnerFrameImageView.centerYAnchor).isActive = true
        centerCircleImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        centerCircleImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        standImageView.topAnchor.constraint(equalTo: spinnerFrameImageView.bottomAnchor, constant: -10).isActive = true
        standImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        standImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        standImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        spinButton.topAnchor.constraint(equalTo: standImageView.bottomAnchor,constant: 20).isActive = true
        spinButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 50).isActive = true
        spinButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -50).isActive = true
        spinButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func searchResult() -> String {
        guard let text = searchBar.text, !text.isEmpty else { return "" }
        return text
    }
}
