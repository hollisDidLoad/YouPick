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
                self?.contentView.presentWebPage(of: finalIndex, completion: { [weak self] webPageVC in
                    self?.present(webPageVC, animated: true)
                })
            })
    }
    
    private func fetchRestaurantsFromSearchedLocation() {
        guard let searchResult = self.contentView.searchResult(), !searchResult.isEmpty else { return }
        viewModel.fetchRestaurantsFromSearchedLocation(with: searchResult, completion: { [weak self] fetchResult in
            switch fetchResult {
            case .success(let updatedSpinWheelModel):
                self?.contentView.spinWheelModel = updatedSpinWheelModel
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
}

//MARK: - Search Bar Delegate

extension SpinWheelViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchRestaurantsFromSearchedLocation()
        searchBar.resignFirstResponder()
    }
}
