//
//  WebPageViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/17/22.
//

import Foundation
import UIKit

class WebPageViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    private let contentView = WebPageView()
    private var sheet: UISheetPresentationController? {
        return presentationController as? UISheetPresentationController
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sheetPresentationSetup()
    }
    
    private func sheetPresentationSetup() {
        sheet?.delegate = self
        sheet?.selectedDetentIdentifier = .medium
        sheet?.prefersGrabberVisible = true
        sheet?.detents = [
            .medium(),
            .large()
        ]
    }
    
    func setUpUrl(with url: URL) {
        guard let url = URL(string: "\(url)") else { return }
        self.contentView.webView.load(URLRequest(url: url))
    }
}
