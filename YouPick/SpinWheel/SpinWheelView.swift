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
    var spinWheelDataModels = [SpinWheelDataModel]()
    private var modelController: RestaurantsModelController
    
    //MARK: - Dependency Injection
    
    init(modelController: RestaurantsModelController) {
        self.modelController = modelController
        super.init(frame: CGRect.zero)
        backgroundColor = .white
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Setup
    
    private let winnerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.textColor = .systemGreen
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
    private let spinnerFrameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "circleGradient")
        return imageView
    }()
    
    private let centerCircleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "darkBlueCenterImage")
        return imageView
    }()
    
    private let pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "darkBlueRightPinImage")
        return imageView
    }()
    
    private let standImageView: UIImageView = {
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
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.placeholder = "Search City Here..."
        return bar
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 0.4
        button.layer.borderColor = UIColor.systemGray4.cgColor
        return button
    }()
    
    //MARK: - Start Up Wheel Setup
    
    private func setUpSlices() {
        let domainModels = modelController.domainModels
        let spinWheelData = domainModels.map { SpinWheelDataModel($0) }
        self.spinWheelDataModels = spinWheelData
        
        for model in spinWheelDataModels {
            guard let name = model.name, let textColor = model.textColor else { return }
            let sliceContent = [Slice.ContentType.text(text: name, preferences: .wheelTextConfiguration(textColor: textColor))]
            let sliceSetup = Slice(contents: sliceContent, backgroundColor: model.backgroundColor)
            slices.append(sliceSetup)
        }
    }
    
    lazy var spinWheel: SwiftFortuneWheel = {
        setUpSlices()
        let spinWheel = SwiftFortuneWheel(
            frame: .zero,
            slices: slices,
            configuration: .wheelConfiguration)
        return spinWheel
    }()
    
    //MARK: - Updated Wheel Setup
    
    private func setUpUpdatedSlices() {
        slices.removeAll()
        let updatedSpinWheelDataModels = spinWheelDataModels
        
        for model in updatedSpinWheelDataModels {
            guard let name = model.name, let textColor = model.textColor else { return }
            let sliceContent = [Slice.ContentType.text(text: name, preferences: .wheelTextConfiguration(textColor: textColor))]
            let sliceSetup = Slice(contents: sliceContent, backgroundColor: model.backgroundColor)
            slices.append(sliceSetup)
        }
    }
    
    private func updateSpinWheel(completion: @escaping (SwiftFortuneWheel) -> Void) {
        setUpUpdatedSlices()
        let updatedSpinWheel = SwiftFortuneWheel(
            frame: .zero,
            slices: slices,
            configuration: .wheelConfiguration)
        completion(updatedSpinWheel)
    }
    
    //MARK: - Constraints
    
    private func setupConstraints() {
        addSubview(searchBar)
        addSubview(searchButton)
        addSubview(winnerLabel)
        addSubview(standImageView)
        addSubview(spinWheel)
        addSubview(spinnerFrameImageView)
        addSubview(pinImageView)
        addSubview(centerCircleImageView)
        addSubview(spinButton)
        
        searchBar.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100).isActive = true
        
        searchButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        searchButton.topAnchor.constraint(equalTo: searchBar.topAnchor).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        searchButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor).isActive = true
        
        winnerLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 30).isActive = true
        winnerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        winnerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        winnerLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        spinWheel.translatesAutoresizingMaskIntoConstraints = false
        spinWheel.widthAnchor.constraint(equalToConstant: 350).isActive = true
        spinWheel.heightAnchor.constraint(equalToConstant: 350).isActive = true
        spinWheel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinWheel.topAnchor.constraint(equalTo: winnerLabel.bottomAnchor,constant: 10).isActive = true
        
        spinnerFrameImageView.topAnchor.constraint(equalTo: spinWheel.topAnchor).isActive = true
        spinnerFrameImageView.leadingAnchor.constraint(equalTo: spinWheel.leadingAnchor).isActive = true
        spinnerFrameImageView.trailingAnchor.constraint(equalTo: spinWheel.trailingAnchor).isActive = true
        spinnerFrameImageView.bottomAnchor.constraint(equalTo: spinWheel.bottomAnchor).isActive = true
        
        pinImageView.leadingAnchor.constraint(equalTo: spinnerFrameImageView.trailingAnchor,constant: -45).isActive = true
        pinImageView.topAnchor.constraint(equalTo: spinWheel.topAnchor,constant: 150).isActive = true
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
    
    //MARK: - Location Search Configuration
    
    private func removeSpinWheel() {
        searchBar.removeFromSuperview()
        searchButton.removeFromSuperview()
        standImageView.removeFromSuperview()
        spinWheel.removeFromSuperview()
        spinnerFrameImageView.removeFromSuperview()
        pinImageView.removeFromSuperview()
        centerCircleImageView.removeFromSuperview()
        spinButton.removeFromSuperview()
    }
    
    private func addUpdatedSpinWheel() {
        updateSpinWheel(completion: { updatedSpinWheel in
            self.spinWheel = updatedSpinWheel
        })
        addSubview(searchBar)
        addSubview(searchButton)
        addSubview(winnerLabel)
        addSubview(standImageView)
        addSubview(spinWheel)
        addSubview(spinnerFrameImageView)
        addSubview(pinImageView)
        addSubview(centerCircleImageView)
        addSubview(spinButton)
        setupConstraints()
    }
    
    func displayUpdatedWheel() {
        removeWinnerLabel()
        removeSpinWheel()
        setUpUpdatedSlices()
        addUpdatedSpinWheel()
    }
    
    func searchResult() -> String? {
        guard let text = searchBar.text, !text.isEmpty else { return nil }
        return text
    }
    
    //MARK: - Spin Button Tapped Configurations
    
    func removeWinnerLabel() {
        winnerLabel.text?.removeAll()
    }
    
    func wheelStartConfigurations(disable tabBarController: UITabBarController?) {
        self.removeWinnerLabel()
        self.spinButton.isEnabled = false
        self.spinButton.setTitle("Wheel is spinning!", for: .normal)
        self.spinButton.backgroundColor = .systemGray
        self.searchBar.isUserInteractionEnabled = false
        self.searchButton.isEnabled = false
        if let items = tabBarController?.tabBar.items {
            items[1].isEnabled = false
        }
    }
    
    func startWheelRotation(endOn index: Int, completion: @escaping (String) -> Void) {
        spinWheel.startRotationAnimation(finishIndex: index, { [weak self] finishedSpinning in
            guard let finalIndexName = self?.spinWheelDataModels[index].name else { return }
            completion(finalIndexName)
        })
    }
    
    func wheelStoppedConfigurations(enable tabBarController: UITabBarController?, winner finalIndexName: String) {
        configureWinnerLabel(with: finalIndexName)
        self.spinButton.isEnabled = true
        self.spinButton.setTitle("Tap to spin again!", for: .normal)
        self.spinButton.backgroundColor = .systemTeal
        self.searchBar.isUserInteractionEnabled = true
        self.searchButton.isEnabled = true
        if let items = tabBarController?.tabBar.items {
            items[1].isEnabled = true
        }
    }
    
    func configureWinnerLabel(with text: String) {
        self.winnerLabel.text = "\(text)!"
    }
    
    func sendErrorAlert(completion: @escaping (UIAlertController) -> Void) {
        guard let invalidSearchResult = self.searchBar.text, !invalidSearchResult.isEmpty else { return }
        let alertController = UIAlertController(
            title: FailedSearchModel.title,
            message: FailedSearchModel.message(invalidSearchResult),
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(
            title: FailedSearchModel.buttonTitle,
            style: .cancel
        ))
        completion(alertController)
    }
}
