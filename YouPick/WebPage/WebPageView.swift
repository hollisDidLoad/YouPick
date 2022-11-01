//
//  WebPageView.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/17/22.
//

import Foundation
import WebKit
import Lottie
import StoreKit
 
class WebPageView: UIView {
    
    let navBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 205/255, green: 46/255, blue: 32/255, alpha: 1.0)
        return view
    }()
    
    let saveRestaurantButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save\nRestaurant", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        button.titleLabel?.numberOfLines = 0
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 4.0
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        let webConfiguration = WKWebViewConfiguration()
        let web = WKWebView(frame: .zero, configuration: webConfiguration)
        web.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 10_1 like Mac OS X) AppleWebKit/602.2.14 (KHTML, like Gecko) Mobile/14B72"
        preferences.preferredContentMode = .recommended
        preferences.allowsContentJavaScript = true
        webConfiguration.defaultWebpagePreferences = preferences
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    var animationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "forkloading")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.backgroundColor = .white
        return animationView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        addSubview(webView)
        addSubview(animationView)
        addSubview(navBarView)
        addSubview(saveRestaurantButton)
        
        navBarView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        navBarView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        navBarView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        navBarView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        saveRestaurantButton.leadingAnchor.constraint(equalTo: navBarView.leadingAnchor, constant: 10).isActive = true
        saveRestaurantButton.topAnchor.constraint(equalTo: navBarView.topAnchor, constant: 10).isActive = true
        saveRestaurantButton.bottomAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: -10).isActive = true
        saveRestaurantButton.widthAnchor.constraint(equalToConstant: 105).isActive = true
        
        
        webView.topAnchor.constraint(equalTo: navBarView.bottomAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        animationView.topAnchor.constraint(equalTo: webView.topAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: webView.bottomAnchor).isActive = true
        animationView.leadingAnchor.constraint(equalTo: webView.leadingAnchor).isActive = true
        animationView.trailingAnchor.constraint(equalTo: webView.trailingAnchor).isActive = true
    }
    
    func removeAnimation() {
        animationView.removeFromSuperview()
    }
    
    func updateSaveButton() {
        saveRestaurantButton.setTitle("Saved!", for: .normal)
        saveRestaurantButton.isEnabled = false
    }
    
    func restaurantAlreadyExistButtonConfiguration() {
        saveRestaurantButton.setTitle("Already\nSaved", for: .normal)
        saveRestaurantButton.setTitleColor(.red, for: .normal)
        saveRestaurantButton.backgroundColor = .yellow
        saveRestaurantButton.isEnabled = false
    }
}
