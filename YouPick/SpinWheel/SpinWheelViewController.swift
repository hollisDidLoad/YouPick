//
//  SpinWheelViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit
import SafariServices
import AppTrackingTransparency

class SpinWheelViewController: UIViewController {
 
    private let coreDataController: CoreDataModelController
    private let internetManager: InternetManager
    private let contentView = SpinWheelView(
        modelController:
            RestaurantsModelController.shared
    )
    private let viewModel = SpinWheelViewModel(
        modelController: RestaurantsModelController.shared,
        networkManager: NetworkManager.shared,
        savedRestaurantsModelController: SavedRestaurantsModelController.shared
    )
    
    init(
        coreDataController: CoreDataModelController,
        internetManager: InternetManager
    ) {
        self.coreDataController = coreDataController
        self.internetManager = internetManager
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
        contentView.searchBar.delegate = self
        contentView.searchButton.addTarget(
            self,
            action: #selector(searchButtonTapped),
            for: .touchUpInside)
        contentView.spinButton.addTarget(
            self,
            action: #selector(spinButtonTapped),
            for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.removeWinnerLabel()
        requestAppTrackingTransparency()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func searchButtonTapped() {
        fetchRestaurantsFromSearchedLocation()
        self.contentView.searchBar.resignFirstResponder()
    }
    
    @objc
    private func spinButtonTapped() {
        let finalIndex = self.viewModel.spinIndex(count: contentView.spinWheel.slices.count)
        contentView.wheelStartConfigurations(disable: tabBarController)
        contentView.startWheelRotation(
            endOn: finalIndex, completion: { [weak self] finalIndexName in
                self?.contentView.wheelStoppedConfigurations(enable: self?.tabBarController, winner: finalIndexName)
                self?.presentWebPage(of: finalIndex, completion: { [weak self] webPage in
                    self?.present(webPage, animated: true)
                })
            })
    }
}

extension SpinWheelViewController {
    
    private func fetchRestaurantsFromSearchedLocation() {
        guard let searchResult = self.contentView.searchResult(), !searchResult.isEmpty else { return }
        viewModel.fetchRestaurants(with: searchResult, completion: { [weak self] fetchResult in
            switch fetchResult {
            case .success(let updatedSpinWheelModel):
                self?.contentView.spinWheelDataModels = updatedSpinWheelModel
                self?.contentView.displayUpdatedWheel()
            case .failure(_):
                self?.sendErrorAlert()
            }
        }, errorCompletion: { [weak self] in
            self?.sendErrorAlert()
        })
    }
    
    private func sendErrorAlert() {
        DispatchQueue.main.async {
            self.contentView.sendErrorAlert(completion: { [weak self] errorAlert in
                self?.present(errorAlert, animated: true)
            })
        }
    }
    
    private func presentWebPage(of index: Int, completion: @escaping (UIViewController) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            let authorizedTracking = UserDefaults.standard.ifAuthorizedTracking
            if self.internetManager.isConnected {
                let webPageVC = WebPageViewController(
                    coreDataController: CoreDataModelController.shared,
                    locationManager: LocationManager.shared,
                    savedRestaurantsModelController: SavedRestaurantsModelController.shared
                )
                guard let url = self.contentView.spinWheelDataModels[index].url else { return }
                self.viewModel.setUpSavedRestaurantsSpinWheelData(with: self.contentView.spinWheelDataModels[index], completion: { model in
                    webPageVC.setUpSavedRestaurantData(with: model)
                })
                if authorizedTracking {
                    webPageVC.setUpUrl(with: url)
                    completion(webPageVC)
                } else {
                    let safariVC = SFSafariViewController(url: url)
                    completion(safariVC)
                }
            } else {
                let noInternetVC = NoInternetConnectionViewController(
                    internetManager: InternetManager.shared
                )
                self.present(noInternetVC, animated: true)
            }
        }
    }
    
    private func requestAppTrackingTransparency() {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            switch status {
            case .restricted, .denied, .notDetermined:
                UserDefaults.standard.ifAuthorizedTracking = false
            case .authorized:
                UserDefaults.standard.ifAuthorizedTracking = true
            @unknown default:
                UserDefaults.standard.ifAuthorizedTracking = false
            }
        })
    }
}

//MARK: - Search Bar Delegate

extension SpinWheelViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchRestaurantsFromSearchedLocation()
        searchBar.resignFirstResponder()
    }
}
