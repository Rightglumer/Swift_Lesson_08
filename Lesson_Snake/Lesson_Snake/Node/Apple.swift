//
//  Apple.swift
//  Lesson_Snake
//
//  Created by Glumer Glumer on 14.06.2020.
//  Copyright © 2020 UCG. All rights reserved.
//

import UIKit
import SpriteKit

class Apple : SKShapeNode {
    
    let APPLE_RADUIS : CGFloat = 10.0
    
    convenience init(position: CGPoint) {
        self.init()
        
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: APPLE_RADUIS, height: APPLE_RADUIS)).cgPath
        fillColor = UIColor.red
        strokeColor = UIColor.red
        lineWidth = 5
        
        self.position = position
        self.physicsBody = SKPhysicsBody(circleOfRadius: APPLE_RADUIS - 3, center: CGPoint(x: 5, y: 5))
        self.physicsBody?.categoryBitMask = CollisionCategories.Apple
    }
}
