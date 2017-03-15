//
//  YQLRouter.swift
//  LunchRadar
//
//  Created by Jedd Goble on 3/12/17.
//  Copyright © 2017 Jedd Goble. All rights reserved.
//

import CoreLocation

protocol YQLDelegate {
    func didRetrieveResults(restaurants: [Restaurant])
}

class YQLRouter: NSObject {
    
    var delegate: YQLDelegate?
    var forceUpdate: Bool = true
    var lastNetworkCallTime = Date().timeIntervalSinceReferenceDate
    
    private let prefix: String = "http://query.yahooapis.com/v1/public/yql?q="
    private let suffix: String = "&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
    var searchTerm: String = "restaurants"
    
    func queryRestaurants(forCoordinates coordinates: CLLocationCoordinate2D) {
        
        let currentTime = Date().timeIntervalSinceReferenceDate
        let timeElapsed = currentTime - lastNetworkCallTime
        
        guard timeElapsed > 10.0 || forceUpdate else {
            print("Not enough time has elapsed to make another network call")
            return
        }
        
        lastNetworkCallTime = currentTime
        forceUpdate = false
        
        let term = "select * from local.search(30) where query=\"\(searchTerm)\" and latitude=\"\(coordinates.latitude)\" and longitude=\"\(coordinates.longitude)\"".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let query = "\(prefix)\(term)\(suffix)"
        print(query)
        let url = URL(string: query)!
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("Error requesting data in YQLRouter: \(error?.localizedDescription)")
                return
            }
            self.deserializeResponse(data)
        }.resume()
    }
    
    func deserializeResponse(_ data: Data) {
        
        do {
            if let jsonDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] {
                mapDictionaryToObjects(jsonDict)
            }
        } catch {
            print("Parsing failed")
        }
    }
    
    func mapDictionaryToObjects(_ jsonDict: [String : Any]) {
        
        guard let query = jsonDict["query"] as? [String : Any], let resultsDict = query["results"] as? [String : Any], let results = resultsDict["Result"] as? [[String : Any]] else {
            return
        }
        
        var restaurants: [Restaurant] = []
        
        for result in results {
            
            var newRestaurant = Restaurant()
            
            if let title = result["Title"] as? String {
                newRestaurant.title = title
            }
            
            if let latString = result["Latitude"] as? String, let latitude = Double(latString), let lonString = result["Longitude"] as? String, let longitude = Double(lonString) {
                
                newRestaurant.location = CLLocation(latitude: latitude, longitude: longitude)
                restaurants.append(newRestaurant)
            }
            // If no coordinates, discard
        }
        
        delegate?.didRetrieveResults(restaurants: restaurants)
    }
}
