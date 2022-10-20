//
//  SpinWheelViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/17/22.
//

import Foundation
import UIKit

class SpinWheelViewModel {
    
    var maxSearchAmount = "10"
    
    func fetchBusinesses( 
        with maxSearch: String,
        with searchResult: String,
        errorCompletion: @escaping (() -> Void),
        completion: @escaping ([RestaurantModel]) -> Void
    ) {
        NetworkManager.shared.fetchBusinesses(
            limit: maxSearch,
            location: searchResult,
            errorCompletion: {
                errorCompletion()
            }, completion: { restaurantAPI in
                RestaurantsModelController.shared.domainModel.removeAll()
                RestaurantsModelController.shared.setUpModelData(with: restaurantAPI, completion: {
                    completion(restaurantAPI)
                })
            })
    }
    
    func responseToFailedSearch(with text: String?, completion: @escaping (UIAlertController) -> Void) {
        guard let results = text else { return }
        let alertController = UIAlertController(title: "Oops!", message:  "Sorry, no results available for: \(results)\nPlease try a different location.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        completion(alertController)
    }
}
