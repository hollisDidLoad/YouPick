//
//  WebPageViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/24/22.
//

import Foundation
import WebKit

class WebPageViewModel {
    
    func loadURL( with webView: WKWebView, and url: URL, completion: @escaping () -> Void) {
        guard let url = URL(string: "\(url)") else { return }
        webView.load(URLRequest(url: url))
        completion()
    }
}
