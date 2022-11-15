//
//  NoInternetConnectionViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 11/14/22.
//

import Foundation
import UIKit

class NoInternetConnectionViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    let contentView = NoInternetConnectionView()
    let internetManager: InternetManager
    
    init(internetManager: InternetManager) {
        self.internetManager = internetManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var sheet: UISheetPresentationController? {
        return presentationController as? UISheetPresentationController
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetConfiguration()
        contentView.retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
    }
    
    private func sheetConfiguration() {
        sheet?.delegate = self
        sheet?.selectedDetentIdentifier = .medium
        sheet?.prefersGrabberVisible = true
        sheet?.detents = [
            .medium(),
            .large()
        ]
    }
    
    @objc
    private func retryButtonTapped() {
        if internetManager.isConnected {
            dismiss(animated: true)
        } else {
            let alert = UIAlertController(title: "Oops!", message: "No internet connection found.\nPlease try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
            present(alert, animated: true)
        }
    }
}

