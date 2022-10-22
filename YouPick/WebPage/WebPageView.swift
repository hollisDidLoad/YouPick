//
//  WebPageView.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/17/22.
//

import Foundation
import UIKit
import WebKit

class WebPageView: UIView {
    
    let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        let webConfiguration = WKWebViewConfiguration()
        let web = WKWebView(frame: .zero, configuration: webConfiguration)
        preferences.allowsContentJavaScript = true
        webConfiguration.defaultWebpagePreferences = preferences
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
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
        
        webView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
