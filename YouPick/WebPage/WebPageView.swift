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
        
        webView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
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
}
