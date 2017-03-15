//
//  LocationManager.swift
//  LunchRadar
//
//  Created by Jedd Goble on 3/12/17.
//  Copyright © 2017 Jedd Goble. All rights reserved.
//

import CoreLocation

protocol LocationDelegate {
    func didUpdateCoordinates(_ coordinates: CLLocationCoordinate2D)
    func didUpdateHeading(_ heading: Double)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager = CLLocationManager()
    
    var delegate: LocationDelegate?
    var currentLocation: CLLocation?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    func requestAuthorization() {
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdating() {
        
        locationManager.requestLocation()
        locationManager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        currentLocation = location
        delegate?.didUpdateCoordinates(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        delegate?.didUpdateHeading(Double(newHeading.trueHeading))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Location Manager failed with error:\(error.localizedDescription)")
    }
    
    func getBearingBetweenTwoPoints(currentLocation: CLLocation, destination: CLLocation) -> Double {
        
        let currentLat = currentLocation.coordinate.latitude.degreesToRadians
        let currentLon = currentLocation.coordinate.longitude.degreesToRadians
        
        let destLat = destination.coordinate.latitude.degreesToRadians
        let destLon = destination.coordinate.longitude.degreesToRadians
        
        let diffLon = destLon - currentLon
        
        let y = sin(diffLon) * cos(destLat)
        let x = cos(currentLat) * sin(destLat) - sin(currentLat) * cos(destLat) * cos(diffLon)
        let bearingInRadians = atan2(y, x)
        
        return bearingInRadians.radiansToDegrees
    }
}
