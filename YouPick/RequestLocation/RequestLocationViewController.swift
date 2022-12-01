//
//  RequestLocationViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/23/22.
//

import Foundation
import UIKit

class RequestLocationViewController: UIViewController {
    
    private var locationManager: LocationManager
    private let contentView = RequestLocationView()
    private let internetManager: InternetManager
    
    init(locationManager: LocationManager, internetManager: InternetManager) {
        self.locationManager = locationManager
        self.internetManager = internetManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if internetManager.isConnected {
            locationManager.requestUserAuthorization()
            locationManager.delegate = self
        } else {
            let noInternetVC = NoInternetConnectionViewController(
                internetManager: InternetManager.shared
            )
            noInternetVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.present(noInternetVC, animated: false)
            }
        }
    }
}

extension RequestLocationViewController: LocationManagerDelegate {
    func didUpdateStatus(_ allowed: Bool) {
        if allowed {
            let tabBarVC = TabBarViewController()
            tabBarVC.modalPresentationStyle = .fullScreen
            present(tabBarVC, animated: true)
        } else {
            contentView.sendErrorAlert(completion: { [weak self] errorAlert in
                self?.present(errorAlert, animated: true)
            })
        }
    }
}
