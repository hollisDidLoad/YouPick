//
//  LoadingScreenView.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/15/22.
//

import Foundation
import UIKit
import Lottie

class LoadingScreenView: UIView {
    
    private let logoImageView: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "youpick")
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    
    var animationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "food")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemTeal
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    private func setUpConstraints() {
        addSubview(animationView)
        addSubview(logoImageView)
        
        logoImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 40).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        animationView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: -80).isActive = true
        animationView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        animationView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
