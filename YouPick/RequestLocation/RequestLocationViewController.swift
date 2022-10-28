//
//  RequestLocationViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/23/22.
//

import Foundation
import UIKit

class RequestLocationViewController: UIViewController {
    
    private let contentView = RequestLocationView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.delegate = self
        LocationManager.shared.requestUserAuthorization()
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
