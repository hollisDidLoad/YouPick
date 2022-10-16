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
    
    var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupAnimationView()
    }
    
    private func setupAnimationView() {
        animationView = .init(name: "foodchoices")
        animationView?.play()
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 0.8
        guard let animationView = animationView else { return }
        view.addSubview(animationView)
        animationView.frame = view.bounds
    }
}
