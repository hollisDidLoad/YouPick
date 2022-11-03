//
//  SavedRestaurantsView.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/31/22.
//

import Foundation
import UIKit

class SavedRestaurantsView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Saved Restaurants"
        label.font = UIFont.systemFont(ofSize: 35, weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView: UITableView = {
       let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        addSubview(titleLabel)
        addSubview(tableView)
        
        titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    func configureCell(with cell: UITableViewCell, and data: SavedRestaurants) {
        cell.textLabel?.text = data.name
        cell.detailTextLabel?.text = data.location
    }
    
    func presentTrackingDeniedAlert(completion: @escaping (UIAlertController) -> Void) {
        let notAuthorizedTracking = UserDefaults.standard.ifAuthorizedTracking == false
        if notAuthorizedTracking {
            let alertController = UIAlertController(title: "Sorry\n", message: "Since app tracking has been denied, we are unable to process our own\nin-app web.\n\nTo save your favorite restaurants, please enable app tracking to\naccess our saving feature.\n\nPreviously saved restaurants \nwill still be available.\n\n Thank you.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .cancel))
            completion(alertController)
        }
    }
}
