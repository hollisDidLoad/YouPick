//
//  WebPageViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/24/22.
//

import Foundation
import WebKit

class WebPageViewModel {
    
    var currentUrl: URL? = nil
    private let coreDataController: CoreDataModelController
    private let domainModel: [RestaurantsDomainModel]
    var webPageSavedModel: WebPageSavedLocationModel?
    
    init(
        modelController: CoreDataModelController,
        domainModel: [RestaurantsDomainModel]
    ) {
        self.coreDataController = modelController
        self.domainModel = domainModel
    }
    
    func loadURL(with webView: WKWebView, and url: URL, completion: @escaping () -> Void) {
        guard let url = URL(string: "\(url)") else { return }
        webView.load(URLRequest(url: url))
        completion()
    }
    
    func reloadUrl(with webView: WKWebView) {
        guard let url = currentUrl else { return }
        webView.load(URLRequest(url: url))
    }
    
    func setUpSavedData(savedLocationDomainModel: SavedLocationDomainModel) {
        self.webPageSavedModel = WebPageSavedLocationModel(data: savedLocationDomainModel)
    }
}
