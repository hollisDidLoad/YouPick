//
//  WebPageViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/17/22.
//

import Foundation
import UIKit
import Lottie
import WebKit
import StoreKit

class WebPageViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    private let contentView = WebPageView()
    private let viewModel = WebPageViewModel()
    private var sheet: UISheetPresentationController? {
        return presentationController as? UISheetPresentationController
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sheetConfiguration()
        self.contentView.webView.navigationDelegate = self
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
    
    private func loadAnimation() {
        contentView.animationView.play()
        contentView.animationView.loopMode = .loop
        contentView.animationView.animationSpeed = 0.8
    }
    
    func setUpUrl(with url: URL) {
        loadAnimation()
        viewModel.loadURL(with: self.contentView.webView, and: url, completion: { [weak self] in
            self?.viewModel.currentUrl = url
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self?.contentView.removeAnimation()
            }
        })
    }
}

extension WebPageViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        if (error as NSError).code == 102 {
            let appStoreVC = AppStoreViewController()
            present(appStoreVC, animated: true)
        }
        viewModel.reloadUrl(with: contentView.webView)
    }
}
