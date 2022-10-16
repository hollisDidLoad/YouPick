//
//  TabBarViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    let viewModel = TabBarViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        let loadingScreenVC = LoadingScreenViewController()
        DispatchQueue.main.async {
            loadingScreenVC.modalPresentationStyle = .fullScreen
            self.present(loadingScreenVC, animated: false)
        }
        NetworkManager.shared.fetchBusinesses(limit: "10", location: "Las Vegas", completion: { [weak self] restaurantAPI in
            self?.viewModel.setupModelData(restaurantAPI, completion: {
                
                self?.setupTabBar()
            })
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            loadingScreenVC.dismiss(animated: true)
        }
    }
}
