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
        setUpSpinButtonTappedConfigurations(winner: finalIndex)
    }
    
    func setUpSpinButtonTappedConfigurations(winner finalIndex: Int) {
        self.contentView.setUpWheelSpinConfigurations(
            winner: finalIndex,
            configure: self.tabBarController,
            completion: { [weak self] webPageVC in
            self?.present(webPageVC, animated: true)
        })
    }
    
    private func fetchSearchedLocationBusinesses() {
        viewModel.fetchBusinesses(
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
        let alertController = UIAlertController(
            title: FailedSearchModel().title,
            message: FailedSearchModel().message(contentView.searchResult()),
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(
            title: FailedSearchModel().buttonTitle,
            style: .cancel
        ))
        present(alertController, animated: true)
    }
    
    private func updateSpinWheel(with restaurantAPI: [RestaurantModel]) {
        self.viewModel.updateSpinWheel(with: restaurantAPI, completion: { [weak self] domainModel in
            self?.contentView.spinWheelModel = domainModel.map { SpinWheelModel($0) }
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
