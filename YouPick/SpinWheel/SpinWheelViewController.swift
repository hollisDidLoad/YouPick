//
//  SpinWheelViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit

class SpinWheelViewController: UITabBarController {
    
    let contentView = SpinWheelView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.searchBar.delegate = self
        contentView.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        contentView.spinButton.addTarget(self, action: #selector(spinButtonTapped), for: .touchUpInside)
    }

    
    @objc
    private func searchButtonTapped() {
        fetchBusinesses()
        contentView.searchBar.resignFirstResponder()
    }
    
    var finishIndex: Int {
        return Int.random(in: 0..<contentView.spinWheel.slices.count)
    }
    
    @objc
    private func spinButtonTapped() {
        let finishingIndex = self.finishIndex
        self.contentView.wheelSpinningButtonConfiguration()
        contentView.spinWheel.startRotationAnimation(finishIndex: finishingIndex) { [weak self] finishedSpinning in
            guard let indexName = self?.contentView.domainModel[finishingIndex].name else { return }
            if finishedSpinning {
                self?.contentView.configureSelectionLabel(with: indexName)
                self?.contentView.wheelStoppedSpinningButtonConfiguration()
            }
        }
    }
    
    func fetchBusinesses() {
        NetworkManager.shared.fetchBusinesses(limit: "10", location: contentView.searchResult(), completion: { restaurantAPI in
            RestaurantsModelController.shared.domainModel = restaurantAPI.map {RestaurantsDomainModel($0)}
        })
    }
}

extension SpinWheelViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchBusinesses()
        searchBar.resignFirstResponder()
    }
}
