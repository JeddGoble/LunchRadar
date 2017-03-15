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
    
    var location: CLLocation?
    var bearing: Double? // In degrees
    var relativeDirection: Double? // In degrees
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

enum ArrowColor {
    case arrowZero
    case arrowOne
    case arrowTwo
    case arrowThree
    case arrowFour
    
    var colorValue: UIColor {
        switch self {
        case .arrowZero:
            return UIColor(colorLiteralRed: 103.0 / 255.0, green: 152.0 / 255.0, blue: 69.0 / 255.0, alpha: 0.7)
        case .arrowOne:
            return UIColor(colorLiteralRed: 207.0 / 255.0, green: 180.0 / 255.0, blue: 52.0 / 255.0, alpha: 0.7)
        case .arrowTwo:
            return UIColor(colorLiteralRed: 55.0 / 255.0, green: 90.0 / 255.0, blue: 123.0 / 255.0, alpha: 0.7)
        case .arrowThree:
            return UIColor(colorLiteralRed: 156.0 / 255.0, green: 71.0 / 255.0, blue: 94.0 / 255.0, alpha: 0.7)
        case .arrowFour:
            return UIColor(colorLiteralRed: 190.0 / 255.0, green: 115.0 / 255.0, blue: 59.0 / 255.0, alpha: 0.7)
        }
    }
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * CGFloat(M_PI) / 180.0 }
    var radiansToDegrees: CGFloat { return self * 180.0 / CGFloat(M_PI) }
}

extension Double {
    var degreesToRadians: Double { return self * M_PI / 180.0 }
    var radiansToDegrees: Double { return self * 180.0 / M_PI }
    var metersToMiles: Double { return (self * 0.000621371 * 100).rounded() / 100 }
}
