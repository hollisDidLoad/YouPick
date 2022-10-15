//
//  TabBarViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBusinesses()
    }
    
    private func setupTabBar() {
        let spinWheelVC = SpinWheelViewController()
        let mapVC = MapViewController()
        
        tabBar.backgroundColor = .systemGray6
        spinWheelVC.tabBarItem = UITabBarItem(title: "Spinner", image: UIImage(named: "spinner"), tag: 1)
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 1)
        
        setViewControllers([spinWheelVC, mapVC], animated: true)
    }
    
    private func fetchBusinesses() {
        NetworkManager.shared.fetchBusinesses(limit: 10, location: "Las Vegas", completion: { restaurantAPI in
            let domainModel = restaurantAPI.map { RestaurantsDomainModel($0)}
            RestaurantsModelController.shared.domainModel = domainModel
            DispatchQueue.main.async {
                self.setupTabBar()
            }
        })
    }
}
