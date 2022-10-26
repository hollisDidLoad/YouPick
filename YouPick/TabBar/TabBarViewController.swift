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
        UITabBar.appearance().barTintColor = .white
        viewModel.fetchCurrentLocation(completion: { [weak self] in
            self?.fetchRestaurants()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpTabBarConifgurations()
    }
    
    private func setUpTabBarConifgurations() {
        tabBar.clipsToBounds = true
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = 90
        tabFrame.origin.y = self.view.frame.size.height - 90
        self.tabBar.frame = tabFrame
    }
    
    private func setUpTabBar() {
        let spinWheelVC = SpinWheelViewController()
        let mapVC = MapViewController()
        
        self.tabBar.backgroundColor = .systemGray6
        spinWheelVC.tabBarItem = UITabBarItem(
            title: "Spinner",
            image: UIImage(named: "spinner"),
            tag: 1)
        mapVC.tabBarItem = UITabBarItem(
            title: "Map",
            image: UIImage(named: "map"),
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
