//
//  SavedRestaurantsViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/31/22.
//

import Foundation
import UIKit
import SafariServices

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
        contentView.presentTrackingDeniedAlert(completion: { [weak self] alert in
            self?.present(alert, animated: true)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }
    
    private func refreshData() {
        coreDataController.retrieveRestaurants { [weak self] in
            self?.contentView.tableView.reloadData()
        }
    }
    
    private func presentWebPage(with indexPath: IndexPath, and url: URL, completion: @escaping (UIViewController) -> Void) {
        let webPageVC = WebPageViewController(
            coreDataController: CoreDataModelController.shared,
            locationManager: LocationManager.shared,
            savedLocationModelController: SavedLocationModelController.shared
        )
        webPageVC.setUpSavedUrlPage(with: url)
        completion(webPageVC)
    }
}

extension SavedRestaurantsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataController.savedRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contentView.tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else { return UITableViewCell() }
        let cellData = coreDataController.savedRestaurants[indexPath.row]
        contentView.configureCell(with: cell, and: cellData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentView.tableView.deselectRow(at: indexPath, animated: true)
        let url = coreDataController.savedRestaurants[indexPath.row].url
        if UserDefaults.standard.ifAuthorizedTracking == true {
            presentWebPage(with: indexPath, and: url, completion: { [weak self] webPageVC in
                self?.present(webPageVC, animated: true)
            })
        } else {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let data = coreDataController.savedRestaurants[indexPath.row]
            self.coreDataController.deleteRestaurantData(with: data)
            self.refreshData()
        }
    }
}
