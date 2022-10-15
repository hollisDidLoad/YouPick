//
//  SpinWheelViewController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
import UIKit

class SpinWheelViewController: UITabBarController {
    
    let contentView = SpinWheelView()

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.searchBar.delegate = self
        searchButtonTapSetup()
        spinButtonTapSetup()
    }
    
    func searchButtonTapSetup() {
        contentView.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func searchButtonTapped() {
        contentView.searchBar.resignFirstResponder()
    }
    
    func spinButtonTapSetup() {
        contentView.spinButton.addTarget(self, action: #selector(spinButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func spinButtonTapped() {
        let randomInt = Int.random(in: 1...10)
        contentView.spinWheel.startRotationAnimation(finishIndex: randomInt, { _ in
        })
    }
}

extension SpinWheelViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
