//
//  TabBarViewModel.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit

class TabBarViewModel {
    
    func setupModelData(_ APIModel: [RestaurantModel], completion: @escaping () -> Void) {
        var domainModel = [RestaurantsDomainModel]()
        var backgroundColors: [UIColor] =
        [.systemOrange, .systemBlue, .systemRed, .systemTeal, .systemPink,.systemGreen,.systemPurple,.systemIndigo,.white,.systemMint]
        var textColors: [UIColor] = [.black, .white, .black, .black, .white, .black, .black, .white, .black, .white]
        for (index, apiModel) in APIModel.enumerated() {
            let model = RestaurantsDomainModel(apiModel, backgroundColor: backgroundColors[index], textColor: textColors[index])
            domainModel.append(model)
        }
        RestaurantsModelController.shared.domainModel = domainModel
        DispatchQueue.main.async {
            completion()
        }
    }
}
