//
//  LunchRadarModels.swift
//  LunchRadar
//
//  Created by Jedd Goble on 3/12/17.
//  Copyright © 2017 Jedd Goble. All rights reserved.
//

import CoreLocation
import UIKit

struct Arrow: Hashable, Equatable, Comparable {
    
    var bearing: Double? // In degrees
    var distance: Double? // In miles
    var color: UIColor?
    var title: String?
    
    var hashValue: Int {
        return "\(distance)\(title)\(bearing)".hashValue
    }
    
    static func ==(lhs: Arrow, rhs: Arrow) -> Bool {
        if lhs.bearing == rhs.bearing && lhs.distance == rhs.bearing && lhs.title == rhs.title {
            return true
        } else {
            return false
        }
    }
    
    static func <(lhs: Arrow, rhs: Arrow) -> Bool {
        if let lhsDistance = lhs.distance, let rhsDistance = rhs.distance {
            return lhsDistance < rhsDistance
        }
        
        return true
    }
}

struct Restaurant {
    
    var title: String?
    var location: CLLocation?
    
}


extension CGFloat {
    var degreesToRadians: CGFloat { return (self - 90.0) * CGFloat(M_PI) / 180.0 }
    var radiansToDegrees: CGFloat { return (self * 180.0 / CGFloat(M_PI)) - 90.0 }
}

extension Double {
    var degreesToRadians: Double { return (self - 90.0) * M_PI / 180.0 }
    var radiansToDegrees: Double { return (self * 180.0 / M_PI) - 90.0 }
    var metersToMiles: Double { return (self * 0.000621371 * 100).rounded() / 100 }
}
