//
//  FetchLocationViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/23/22.
//

import Foundation
import UIKit

class FetchLocationViewController: UIViewController {
    
    let contentView = FetchLocationView()
    let viewModel = FetchLocationViewModel()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.delegate = self
        LocationManager.shared.requestCurrentLocation({_ in})
    }
    
}

extension FetchLocationViewController: LocationManagerDelegate {
    func didUpdateStatus(_ allowed: Bool) {
        if allowed {
            let tabBarVC = TabBarViewController()
            tabBarVC.modalPresentationStyle = .fullScreen
            self.present(tabBarVC, animated: false)
        } else {
            contentView.sendErrorAlert(completion: { [weak self] errorAlert in
                self?.present(errorAlert, animated: true)
            })
        }
    }
}
