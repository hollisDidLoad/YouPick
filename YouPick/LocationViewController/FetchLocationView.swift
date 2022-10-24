//
//  FetchLocationView.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/23/22.
//

import Foundation
import UIKit

class FetchLocationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sendErrorAlert(completion: @escaping (UIAlertController) -> Void) {
        let alertController = UIAlertController(
            title: FetchLocationDeniedModel().title,
            message: FetchLocationDeniedModel().message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(
            title: FetchLocationDeniedModel().buttonTitle,
            style: .cancel,
            handler: { _ in
                if let bundleId = Bundle.main.bundleIdentifier,
                   let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
                {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
        completion(alertController)
    }
}
