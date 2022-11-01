//
//  SavedRestaurantsViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/31/22.
//

import Foundation
import UIKit

class SavedRestaurantsViewController: UIViewController {
    
    private let contentView = SavedRestaurantsView()
    private let coreDataController: CoreDataModelController
    
    init(coreDataController: CoreDataModelController) {
        self.coreDataController = coreDataController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }
    
    private func refreshData() {
        coreDataController.retrieveRestaurants { [weak self] in
            self?.contentView.tableView.reloadData()
        }
    }
}

extension SavedRestaurantsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataController.savedRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contentView.tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else { return UITableViewCell() }
        let data = coreDataController.savedRestaurants[indexPath.row]
        cell.textLabel?.text = data.name
        cell.detailTextLabel?.text = data.location
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentView.tableView.deselectRow(at: indexPath, animated: true)
        contentView.presentWebPage(with: indexPath, and: coreDataController, completion: { [weak self] webPageVC in
            self?.present(webPageVC, animated: true)
        })
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let data = coreDataController.savedRestaurants[indexPath.row]
            self.coreDataController.deleteRestaurantData(with: data)
            self.refreshData()
        }
    }
}
