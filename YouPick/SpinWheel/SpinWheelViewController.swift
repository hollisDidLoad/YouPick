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
    private var spinIndex: Int {
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
        fetchSearchedLocationBusinesses()
        self.contentView.searchBar.resignFirstResponder()
    }
    
    @objc
    private func spinButtonTapped() {
        let finalIndex = self.spinIndex
        spinButtonTappedConfigurations(winner: finalIndex)
    }
    
    func spinButtonTappedConfigurations(winner finalIndex: Int) {
        self.contentView.wheelSpinConfigurations(
            winner: finalIndex,
            configure: self.tabBarController,
            completion: { [weak self] webPageVC in
            self?.present(webPageVC, animated: true)
        })
    }
    
    private func fetchSearchedLocationBusinesses() {
        viewModel.fetchBusinesses(
            limit: viewModel.maxSearchLimit,
            with: contentView.searchResult(),
            completion: { [weak self] fetchResults in
                switch fetchResults {
                case .success(let restaurantAPI):
                    if restaurantAPI.count != 0 {
                        self?.updateSpinWheel(with: restaurantAPI)
                    } else {
                        self?.sendErrorAlert()
                    }
                case .failure(_):
                    self?.sendErrorAlert()
                }
            })
    }
}

//MARK: - User Search Confirguations

extension SpinWheelViewController {
    
    private func sendErrorAlert() {
        DispatchQueue.main.async {
            self.contentView.receivedErrorOnSearch(
                completion: { [weak self] alertController in
                self?.present(alertController, animated: true)
            })
        }
    }
    
    private func updateSpinWheel(with restaurantAPI: [RestaurantModel]) {
        self.viewModel.updateSpinWheel(with: restaurantAPI, completion: { [weak self] domainModel in
            guard let domainModel = domainModel else { return }
            self?.contentView.domainModel = domainModel
            DispatchQueue.main.async {
                self?.contentView.displayUpdatedData()
            }
        })
    }
}

//MARK: - Search Bar Delegate

extension SpinWheelViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchSearchedLocationBusinesses()
        searchBar.resignFirstResponder()
    }
}
