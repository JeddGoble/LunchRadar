//
//  ViewController.swift
//  LunchRadar
//
//  Created by Jedd Goble on 3/12/17.
//  Copyright © 2017 Jedd Goble. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    var locationManager: LocationManager = LocationManager()
    var yqlRouter: YQLRouter = YQLRouter()
    
    var arrows: [Arrow] = []
    
    @IBOutlet weak var radarView: RadarView!
    @IBOutlet weak var legendTableView: UITableView! {
        didSet {
            legendTableView.dataSource = self
            legendTableView.delegate = self
            let nib = UINib(nibName: LegendTableViewCell.reuseID, bundle: nil)
            legendTableView.register(nib, forCellReuseIdentifier: LegendTableViewCell.reuseID)
        }
    }
    
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yqlRouter.delegate = self
        
        locationManager.delegate = self
        locationManager.requestAuthorization()
        locationManager.startUpdating()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    @IBAction func onReloadButtonTapped(_ sender: UIButton) {
        reloadButton.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        yqlRouter.forceUpdate = true
    }
    
}

extension ViewController: LocationDelegate {
    
    func didUpdateLocation(_ currentLocation: CLLocation) {
        
        arrows = arrows.map({ (arrow) -> Arrow in
            if let restaurantLocation = arrow.location {
                let newBearing = self.locationManager.getBearingBetweenTwoPoints(currentLocation: currentLocation, destination: restaurantLocation)
                let newArrow = Arrow(location: arrow.location, bearing: newBearing, relativeDirection: arrow.relativeDirection, distance: arrow.distance, color: arrow.color, title: arrow.title)
                return newArrow
            }
            return arrow
        })
        
        // Note: YQLRouter will refuse to make a network call unless 10 seconds has elapsed.
        yqlRouter.queryRestaurants(forCoordinates: currentLocation.coordinate)
    }
    
    func didUpdateHeading(_ heading: Double) {
        
        arrows = arrows.map { (arrow) -> Arrow in
            
            if let bearing = arrow.bearing {
                let relativeDirection = -(heading - bearing) - 90.0 // Note: This is super buggy indoors. Optomizing for outside.
                return Arrow(location: arrow.location, bearing: bearing, relativeDirection: relativeDirection, distance: arrow.distance, color: arrow.color, title: arrow.title)
            } else {
                return arrow
            }
        }
        
        radarView.arrows = arrows
        DispatchQueue.main.async { self.legendTableView.reloadData() }
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        reloadButton.isHidden = false
    }
}

extension ViewController: YQLDelegate {
    
    func didRetrieveResults(restaurants: [Restaurant]) {
        guard let currentLocation = locationManager.currentLocation else {
            print("Error: No current location stored in Location Manager")
            return
        }
        
        var allArrows = Set<Arrow>()
        
        for restaurant in restaurants {
            
            guard let location = restaurant.location else {
                print("Restaurant contains no location data. Moving on.")
                continue
            }
            
            var newArrow = Arrow()
            
            newArrow.location = restaurant.location
            newArrow.bearing = locationManager.getBearingBetweenTwoPoints(currentLocation: currentLocation, destination: location)
            newArrow.distance = location.distance(from: currentLocation)
            newArrow.title = restaurant.title
            
            allArrows.insert(newArrow)
        }
        
        let arrowsSorted = allArrows.sorted(by: <)
        var arrows: [Arrow] = []
        
        for (i, arrow) in arrowsSorted.enumerated() {
            
            guard i < 5 else {
                break
            }
            
            var color: UIColor = UIColor.lightGray
            
            switch i {
            case 0:
                color = ArrowColor.arrowZero.colorValue
            case 1:
                color = ArrowColor.arrowOne.colorValue
            case 2:
                color = ArrowColor.arrowTwo.colorValue
            case 3:
                color = ArrowColor.arrowThree.colorValue
            case 4:
                color = ArrowColor.arrowFour.colorValue
            default:
                break
            }
            
            let newArrow = Arrow(location: arrow.location, bearing: arrow.bearing, relativeDirection: arrow.relativeDirection, distance: arrow.distance, color: color, title: arrow.title)
            arrows.append(newArrow)
        }
        
        self.arrows = arrows
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LegendTableViewCell.reuseID, for: indexPath) as! LegendTableViewCell
        cell.selectionStyle = .none
        
        let arrow = arrows[indexPath.row]
        var displayedText = ""
        
        if let distance = arrow.distance {
            displayedText += "\(distance.metersToMiles) miles"
        }
        
        if let restaurantName = arrow.title {
            displayedText += " - " + restaurantName
        } else {
            displayedText = " - Unknown Restaurant"
        }
        
        cell.nameLabel.text = displayedText
        
        if let color = arrow.color {
            cell.squareView.backgroundColor = color
        } else {
            cell.squareView.backgroundColor = UIColor.lightGray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrows.count
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
