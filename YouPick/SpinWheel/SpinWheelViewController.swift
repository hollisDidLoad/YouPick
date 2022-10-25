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
        contentView.setKeyBoardTapGestureDismissal(with: self, completion: { [weak self] tap in
            self?.view.addGestureRecognizer(tap)
        })
    }
    
    
    @objc
    private func searchButtonTapped() {
        fetchRestaurantsFromSearchedLocation()
        self.contentView.searchBar.resignFirstResponder()
    }
    
    @objc
    private func spinButtonTapped() {
        let finalIndex = self.spinIndex
        contentView.wheelWillSpinConfigurations(disable: tabBarController)
        contentView.startWheelSpinRotation(endOn: finalIndex, completion: { [weak self] finalIndexName in
            self?.contentView.wheelStoppedConfiguration(enable: self?.tabBarController, winner: finalIndexName)
            self?.contentView.presentWebPage(with: finalIndex, completion: { [weak self] webPageVC in
                self?.present(webPageVC, animated: true)
            })
        })
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - User Search Confirguations

extension SpinWheelViewController {
    
    private func fetchRestaurantsFromSearchedLocation() {
        guard let searchResult = contentView.searchResult(), !searchResult.isEmpty else { return }
        viewModel.fetchRestaurantsFromSearchedLocation(
            with: searchResult,
            completion: { [weak self] fetchResults in
                switch fetchResults {
                case .success(let restaurantAPI):
                    if restaurantAPI.count != 0 {
                        self?.viewModel.updateSpinWheel(with: restaurantAPI, completion: { updatedSpinWheelModel in
                            self?.contentView.spinWheelModel = updatedSpinWheelModel
                            DispatchQueue.main.async {
                                self?.contentView.displayUpdatedWheel()
                            }
                        })
                    } else {
                        self?.sendErrorAlert()
                    }
                case .failure(_):
                    self?.sendErrorAlert()
                }
            })
    }
    
    private func sendErrorAlert() {
        DispatchQueue.main.async {
            guard let searchResult = self.contentView.searchResult(), !searchResult.isEmpty else { return }
            self.contentView.sendErrorAlert(searchResult: searchResult, { [weak self] errorAlert in
                self?.present(errorAlert, animated: true)
            })
        }
    }
}

//MARK: - Search Bar Delegate

extension SpinWheelViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchRestaurantsFromSearchedLocation()
        searchBar.resignFirstResponder()
    }
}
