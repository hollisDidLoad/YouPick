//
//  TabBarViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    private let viewModel = TabBarViewModel(
        modelController: RestaurantsModelController.shared,
        locationManager: LocationManager.shared,
        networkManager: NetworkManager.shared
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.clipsToBounds = true
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .darkGray
        viewModel.fetchCurrentLocation(completion: { [weak self] in
            self?.fetchRestaurants()
        })
    }
    
    private func setUpTabBar() {
        let spinWheelVC = SpinWheelViewController()
        let mapVC = MapViewController(
            locationManager: LocationManager.shared
        )
        
        self.tabBar.backgroundColor = .systemGray6
        spinWheelVC.tabBarItem = UITabBarItem(
            title: "Spinner",
            image: UIImage(systemName: "line.3.crossed.swirl.circle"),
            tag: 1)
        mapVC.tabBarItem = UITabBarItem(
            title: "Map",
            image: UIImage(systemName: "map"),
            tag: 1)
        
        self.setViewControllers([spinWheelVC, mapVC], animated: true)
    }
    
    private func fetchRestaurants() {
        let loadingScreenVC = LoadingScreenViewController()
        loadingScreenVC.modalPresentationStyle = .fullScreen
        self.present(loadingScreenVC, animated: false)
        
        self.viewModel.fetchAPIData(completion: { [weak self] in
            DispatchQueue.main.async {
                self?.setUpTabBar()
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            loadingScreenVC.dismiss(animated: true)
        }
    }
}
