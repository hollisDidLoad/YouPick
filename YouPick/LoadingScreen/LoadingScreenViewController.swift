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
    
    let contentview = LoadingScreenView()
    var animationView: LottieAnimationView?
    
    override func loadView() {
        view = contentview
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentview.animateLoadingScreen()
    }
}
