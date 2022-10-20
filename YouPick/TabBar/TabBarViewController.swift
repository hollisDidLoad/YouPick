//
//  TabBarViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    private let viewModel = TabBarViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.fetchCurrentLocation(completion: { [weak self] in
            self?.fetchBusinesses()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UITabBar.appearance().unselectedItemTintColor = .darkGray
        setUpTabBarHeight()
    }
    
    private func setUpTabBarHeight() {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = 90
        tabFrame.origin.y = self.view.frame.size.height - 90
        self.tabBar.frame = tabFrame
    }
    
    private func setupTabBar() {
        let spinWheelVC = SpinWheelViewController()
        let mapVC = MapViewController()
        
        tabBar.backgroundColor = .systemGray6
        spinWheelVC.tabBarItem = UITabBarItem(
            title: "Spinner",
            image: UIImage(named: "spinner"),
            tag: 1)
        mapVC.tabBarItem = UITabBarItem(
            title: "Map",
            image: UIImage(systemName: "map"),
            tag: 1)
        
        setViewControllers([spinWheelVC, mapVC], animated: true)
    }
    
    private func fetchBusinesses() {
        let loadingScreenVC = LoadingScreenViewController()
        loadingScreenVC.modalPresentationStyle = .fullScreen
        self.present(loadingScreenVC, animated: false)
        
        viewModel.fetchBusinesses(
            with: viewModel.locationName,
            completion: { restaurantAPI in
                RestaurantsModelController.shared.setUpModelData(
                    with: restaurantAPI, completion: {
                        self.setupTabBar()
                    })
            })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            loadingScreenVC.dismiss(animated: true)
        }
    }
}
