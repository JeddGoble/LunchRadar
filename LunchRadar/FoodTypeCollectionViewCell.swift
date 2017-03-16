//
//  FoodTypeCollectionViewCell.swift
//  LunchRadar
//
//  Created by jgoble52 on 3/15/17.
//  Copyright © 2017 Jedd Goble. All rights reserved.
//

import UIKit

class FoodTypeCollectionViewCell: UICollectionViewCell {
    
    static var reuseID: String {
        return String(describing: FoodTypeCollectionViewCell.self)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    

}
