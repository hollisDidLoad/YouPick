//
//  SpinWheelViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit

class SpinWheelViewController: UIViewController {
    
    private let contentView = SpinWheelView()
    private let viewModel = SpinWheelViewModel()
    private var Index: Int {
        return Int.random(in: 0..<contentView.spinWheel.slices.count)
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
        
    }
    
    @objc
    private func searchButtonTapped() {
        fetchBusinesses()
        self.contentView.searchBar.resignFirstResponder()
    }
    
    @objc
    private func spinButtonTapped() {
        let finalIndex = self.Index
        self.contentView.wheelSpinningConfigurations(with: self.tabBarController)
        startRotation(with: finalIndex, completion: { [weak self] finishedSpinning in
            guard let finalIndexName = self?.contentView.domainModel[finalIndex].name else { return }
            if finishedSpinning {
                self?.contentView.configureWinnerLabel(with: finalIndexName)
                self?.contentView.wheelStoppedSpinningConfigurations(with: self?.tabBarController, completion: {
                    guard let url = self?.contentView.domainModel[finalIndex].url else { return }
                    self?.presentWebPage(with: url)
                })
            }
        })
    }
    
    private func startRotation(with finalIndex: Int, completion: @escaping (Bool) -> Void) {
        contentView.spinWheel.startRotationAnimation(finishIndex: finalIndex, { finishedSpinning in
            completion(finishedSpinning)
        })
    }
    
    private func presentWebPage(with url: URL) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            let selectedRestaurantVC = WebPageViewController()
            selectedRestaurantVC.modalPresentationStyle = .formSheet
            selectedRestaurantVC.setUpUrl(with: url)
            self.present(selectedRestaurantVC, animated: true)
        }
    }
    
    private func fetchBusinesses() {
        viewModel.fetchBusinesses(
            with: viewModel.maxSearchAmount,
            with: contentView.searchResult(), errorCompletion: { [weak self] in
                DispatchQueue.main.async {
                    self?.viewModel.responseToFailedSearch(with: self?.contentView.searchResult(), completion: { alertController in
                        self?.present(alertController, animated: true)
                    })
                }
            },
            completion: { [weak self] restaurantAPI in
                if restaurantAPI.count != 0 {
                    RestaurantsModelController.shared.setUpModelData(with: restaurantAPI, completion: {
                        self?.contentView.domainModel = RestaurantsModelController.shared.domainModel
                        self?.displayUpdatedData()
                    })
                } else {
                    self?.viewModel.responseToFailedSearch(with: self?.contentView.searchResult(), completion: { [weak self] alertController in
                        self?.present(alertController, animated: true)
                    })
                }
            })
    }
    
    private func displayUpdatedData() {
        DispatchQueue.main.async {
            self.contentView.removeSpinWheel()
            self.contentView.setupUpdatedSlices()
            self.contentView.addUpdatedSpinWheel()
        }
    }
}

extension SpinWheelViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchBusinesses()
        searchBar.resignFirstResponder()
    }
}
