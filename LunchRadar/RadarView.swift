//
//  RadarView.swift
//  LunchRadar
//
//  Created by Jedd Goble on 3/12/17.
//  Copyright © 2017 Jedd Goble. All rights reserved.
//

import UIKit
import CoreLocation

@IBDesignable
class RadarView: UIView {
    
    var arrows: [Arrow] = [] {
        didSet {
            DispatchQueue.main.async { self.setNeedsDisplay() }
        }
    }
    
    var circleSizeFactor: CGFloat = 0.35
    var arrowSizeFactor: CGFloat = 1.4
    
    var circleColor: UIColor = UIColor.clear
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // MARK: Draw circle
        
        let minBoxDimension = min(rect.width, rect.height)
        let circleDiameter = minBoxDimension * circleSizeFactor
        let offset: CGFloat = ((1.0 - circleSizeFactor) / 2.0) * minBoxDimension
        let boxForCircle = CGRect(x: offset, y: offset, width: circleDiameter, height: circleDiameter)
        
        let circle = UIBezierPath(ovalIn: boxForCircle)
        circleColor.setFill()
        circle.fill()
        
        // MARK: Add arrows
        
        let circleCenter = CGPoint(x: minBoxDimension / 2.0, y: minBoxDimension / 2.0)
        
        // Reverse so that closest is added last and on top of the others
        let arrowsReverse = arrows.reversed()
        
        for arrow in arrowsReverse {
            
            let color: UIColor = (arrow.color != nil) ? arrow.color! : UIColor.lightGray
            
            drawArrow(arrow, onCircleWithRadius: circleDiameter / 2.0, withCenter: circleCenter, andColor: color)
        }
    }
    
    func drawArrow(_ arrow: Arrow, onCircleWithRadius radius: CGFloat, withCenter center: CGPoint, andColor color: UIColor) {
        
        guard let relativeDirection = arrow.relativeDirection else {
            print("Arrow contains no direction data")
            return
        }
        
        // MARK: Draw arrow
        let startRadians = CGFloat((relativeDirection - 45.0).degreesToRadians)
        let endRadians = CGFloat((relativeDirection + 45.0).degreesToRadians)
        
        let outline = UIBezierPath()
        
        var startPoint = CGPoint()
        startPoint.x = center.x + radius * cos(startRadians)
        startPoint.y = center.y + radius * sin(startRadians)
        
        outline.move(to: startPoint)
        
        var endPoint = CGPoint()
        endPoint.x = center.x + radius * cos(endRadians)
        endPoint.y = center.y + radius * sin(endRadians)
        
        outline.addArc(withCenter: center, radius: radius, startAngle: startRadians, endAngle: endRadians, clockwise: true)
        
        let arrowPointRadians = CGFloat(relativeDirection.degreesToRadians)
        
        var arrowPoint = CGPoint()
        arrowPoint.x = center.x + (radius + (radius * arrowSizeFactor)) * cos(arrowPointRadians)
        arrowPoint.y = center.y + (radius + (radius * arrowSizeFactor)) * sin(arrowPointRadians)
        
        outline.addLine(to: arrowPoint)
        outline.addLine(to: startPoint)
        
        color.setFill()
        
        outline.fill()
        
    }
}

