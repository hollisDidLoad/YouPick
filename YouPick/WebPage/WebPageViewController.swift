//
//  WebPageViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/17/22.
//

import Foundation
import UIKit
import Lottie
import WebKit
import StoreKit

class WebPageViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    private let contentView = WebPageView()
    private let viewModel = WebPageViewModel(
        modelController: CoreDataModelController.shared,
        domainModel: RestaurantsModelController.shared.domainModels
    )
    private let locationManager: LocationManager
    private var sheet: UISheetPresentationController? {
        return presentationController as? UISheetPresentationController
    }
    private let coreDataController: CoreDataModelController
    private let savedLocationModelController: SavedLocationModelController
    
    init(coreDataController: CoreDataModelController, locationManager: LocationManager, savedLocationModelController: SavedLocationModelController) {
        self.coreDataController = coreDataController
        self.locationManager = locationManager
        self.savedLocationModelController = savedLocationModelController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sheetConfiguration()
        self.contentView.webView.navigationDelegate = self
        self.contentView.saveRestaurantButton.addTarget(
            self,
            action: #selector(didTapSaveRestaurant),
            for: .touchUpInside)
    }
    
    @objc
    private func didTapSaveRestaurant() {
        setUpWebData()
    }
    
    private func sheetConfiguration() {
        sheet?.delegate = self
        sheet?.selectedDetentIdentifier = .medium
        sheet?.prefersGrabberVisible = true
        sheet?.detents = [
            .medium(),
            .large()
        ]
    }
    
    private func loadAnimation() {
        contentView.animationView.play()
        contentView.animationView.loopMode = .loop
        contentView.animationView.animationSpeed = 0.8
    }
}

//MARK: - WebData Setup

extension WebPageViewController {
    
    private func setUpWebData() {
        let indexName = coreDataController.savedRestaurants.map { $0.name }
        guard let name = viewModel.webPageSavedModel?.name,
              let url = viewModel.webPageSavedModel?.url,
              let location = viewModel.webPageSavedModel?.location
        else { return }
        if indexName.contains(name) {
            contentView.restaurantAlreadyExistButtonConfiguration()
        } else {
            contentView.updateSaveButton()
            coreDataController.createRestaurantData(
                with: name,
                url,
                and: location)
            coreDataController.retrieveRestaurants { [weak self] in
                self?.coreDataController.saveData()
            }
        }
    }
    
    func setUpUrl(with url: URL) {
        loadAnimation()
        viewModel.loadURL(with: self.contentView.webView, and: url, completion: { [weak self] in
            self?.viewModel.currentUrl = url
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self?.contentView.removeAnimation()
            }
        })
    }
    
    func setUpSavedUrlPage(with url: URL) {
        loadAnimation()
        self.contentView.saveRestaurantButton.removeFromSuperview()
        viewModel.loadURL(with: self.contentView.webView, and: url, completion: { [weak self] in
            self?.viewModel.currentUrl = url
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self?.contentView.removeAnimation()
            }
        })
    }
    
    func setUpSavedLocationData(with domainModel: SavedLocationDomainModel) {
        viewModel.setUpSavedData(savedLocationDomainModel: domainModel)
    }
}

//MARK: - WebNavigation Delegate

extension WebPageViewController: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation,
        withError error: Error
    ) {
        if (error as NSError).code == 102 {
            let appStoreVC = AppStoreViewController()
            present(appStoreVC, animated: true)
        }
        viewModel.reloadUrl(with: contentView.webView)
    }
}
