//
//  FoodTypeSelectView.swift
//  LunchRadar
//
//  Created by jgoble52 on 3/15/17.
//  Copyright © 2017 Jedd Goble. All rights reserved.
//

import UIKit

protocol FoodSelectProtocol {
    func didSelectFoodType(foodName: String)
}

class FoodTypeSelectView: UIView {

    var delegate: FoodSelectProtocol?
    
    static var nibName: String {
        return String(describing: FoodTypeSelectView.self)
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let nib = UINib(nibName: FoodTypeCollectionViewCell.reuseID, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: FoodTypeCollectionViewCell.reuseID)
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    
    var foodTypes: [String] {
        return ["Pizza", "Sandwiches", "Mexican", "Mediterranean", "Chinese", "Indian", "Sushi", "American"]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

extension FoodTypeSelectView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodTypeCollectionViewCell.reuseID, for: indexPath) as! FoodTypeCollectionViewCell
        cell.titleLabel.text = foodTypes[indexPath.item]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodTypes.count
    }
}

extension FoodTypeSelectView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let foodName = foodTypes[indexPath.item]
        delegate?.didSelectFoodType(foodName: foodName)
    }
    
}

extension FoodTypeSelectView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 140.0, height: 140.0)
    }
    
}
