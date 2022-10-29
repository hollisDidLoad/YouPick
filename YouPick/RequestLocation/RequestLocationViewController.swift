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
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestUserAuthorization()
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
