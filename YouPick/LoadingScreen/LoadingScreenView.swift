//
//  StartUpLoadingScreenView.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/15/22.
//

import Foundation
import UIKit
import Lottie

class LoadingScreenView: UIView {
    
    var animationView: LottieAnimationView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        animationView = .init(name: "foodchoices")
        animationView?.play()
        animationView?.loopMode = .loop
        guard let animationView = animationView else { return }
        addSubview(animationView)
        animationView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAnimationView() {
        animationView = .init(name: "foodchoices")
        animationView?.play()
        animationView?.loopMode = .loop
        guard let animationView = animationView else { return }
        addSubview(animationView)
        animationView.frame = bounds
    }
}
