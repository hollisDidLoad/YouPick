//
//  CustomCell.swift
//  YouPick
//
//  Created by Hollis Kwan on 11/1/22.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
    static let identifier = "CustomCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
