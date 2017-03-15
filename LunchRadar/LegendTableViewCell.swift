//
//  LegendTableViewCell.swift
//  LunchRadar
//
//  Created by Jedd Goble on 3/15/17.
//  Copyright © 2017 Jedd Goble. All rights reserved.
//

import UIKit

class LegendTableViewCell: UITableViewCell {

    static var reuseID: String {
        return String(describing: LegendTableViewCell.self)
    }
    
    @IBOutlet weak var squareView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
}
