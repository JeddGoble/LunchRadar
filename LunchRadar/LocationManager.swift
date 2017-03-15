//
//  LocationManager.swift
//  LunchRadar
//
//  Created by Jedd Goble on 3/12/17.
//  Copyright © 2017 Jedd Goble. All rights reserved.
//

import CoreLocation

protocol LocationDelegate {
    func didUpdateLocation(_ location: CLLocation)
    func didUpdateHeading(_ heading: Double)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager = CLLocationManager()
    
    var delegate: LocationDelegate?
    var currentLocation: CLLocation?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestAuthorization() {
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdating() {
        
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        currentLocation = location
        delegate?.didUpdateLocation(location)
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
        
        let dLon = destLon - currentLon
        
        let y = sin(dLon) * cos(destLat)
        let x = cos(currentLat) * sin(destLat) - sin(currentLat) * cos(destLat) * cos(dLon)
        let bearingInRadians = atan2(y, x)
        let bearingInDegrees = bearingInRadians.radiansToDegrees
        
        return bearingInDegrees
    }
}
