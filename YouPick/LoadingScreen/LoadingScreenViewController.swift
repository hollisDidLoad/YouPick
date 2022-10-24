//
//  LoadingScreenViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/15/22.
//

import Foundation
import UIKit
import Lottie

class LoadingScreenViewController: UIViewController {
    
    private let contentView = LoadingScreenView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLoadingScreen()
    }
    
    private func animateLoadingScreen() {
        contentView.animationView.play()
        contentView.animationView.loopMode = .loop
        contentView.animationView.animationSpeed = 0.8
    }
}
