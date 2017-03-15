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
            return UIColor(colorLiteralRed: 103.0 / 255.0, green: 152.0 / 255.0, blue: 69.0 / 255.0, alpha: 1.0)
        case .arrowOne:
            return UIColor(colorLiteralRed: 148.0 / 255.0, green: 165.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0)
        case .arrowTwo:
            return UIColor(colorLiteralRed: 53.0 / 255.0, green: 116.0 / 255.0, blue: 92.0 / 255.0, alpha: 1.0)
        case .arrowThree:
            return UIColor(colorLiteralRed: 156.0 / 255.0, green: 71.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)
        case .arrowFour:
            return UIColor(colorLiteralRed: 172.0 / 255.0, green: 107.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
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
