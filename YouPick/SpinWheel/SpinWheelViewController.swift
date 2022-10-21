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
        fetchSearchedLocationBusinesses()
        self.contentView.searchBar.resignFirstResponder()
    }
    
    @objc
    private func spinButtonTapped() {
        let finalIndex = self.Index
        spinButtonTappedConfigurations(finalIndex)
    }
    
    func spinButtonTappedConfigurations(_ index: Int) {
        self.contentView.wheelStartedSpinningConfigurations(disable: self.tabBarController)
        startSpinWheelRotation(endOn: index, completion: { [weak self] finishedSpinning in
            guard let finalIndexName = self?.viewModel.domainModel[index].name else { return }
            self?.wheelFinishesSpinningConfigurations(finalIndexName, index)
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

extension SpinWheelViewController {
    
    //MARK: - Spin Wheel Tapped Configurations
    
    private func startSpinWheelRotation(endOn finalIndex: Int, completion: @escaping (Bool) -> Void) {
        contentView.spinWheel.startRotationAnimation(finishIndex: finalIndex, { finishedSpinning in
            completion(finishedSpinning)
        })
    }
    
    private func wheelFinishesSpinningConfigurations(_ finalIndexName: String,_ index: Int) {
        self.contentView.configureWinnerLabel(with: finalIndexName)
        self.contentView.wheelStoppedSpinningConfigurations(enable: self.tabBarController, completion: {
            guard let url = self.viewModel.domainModel[index].url else { return }
            self.presentWebPage(with: url)
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
    
    //MARK: - User Search Confirguations
    
    func sendErrorAlert() {
        self.contentView.responseToFailedSearch(completion: { [weak self] alertController in
            self?.present(alertController, animated: true)
        })
    }
    
    func updateSpinWheel(with restaurantAPI: [RestaurantModel]) {
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
