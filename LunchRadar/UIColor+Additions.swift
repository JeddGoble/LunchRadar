//
//  UIColor+Additions.swift
//  LunchRadar
//
//  Created by Jedd Goble on 3/14/17.
//  Copyright © 2017 Jedd Goble. All rights reserved.
//

import UIKit

enum ArrowColor {
    case arrowZero
    case arrowOne
    case arrowTwo
    case arrowThree
    case arrowFour
    
    var colorValue: UIColor {
        switch self {
        case .arrowZero:
            return UIColor(colorLiteralRed: 172.0 / 255.0, green: 107.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
        case .arrowOne:
            return UIColor(colorLiteralRed: 156.0 / 255.0, green: 71.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)
        case .arrowTwo:
            return UIColor(colorLiteralRed: 53.0 / 255.0, green: 116.0 / 255.0, blue: 92.0 / 255.0, alpha: 1.0)
        case .arrowThree:
            return UIColor(colorLiteralRed: 148.0 / 255.0, green: 165.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0)
        case .arrowFour:
            return UIColor(colorLiteralRed: 103.0 / 255.0, green: 152.0 / 255.0, blue: 69.0 / 255.0, alpha: 1.0)
        }
    }
}


