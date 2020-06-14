//
//  SnakeBodyPart.swift
//  Lesson_Snake
//
//  Created by Glumer Glumer on 14.06.2020.
//  Copyright © 2020 UCG. All rights reserved.
//

import UIKit
import SpriteKit

class SnakeBodyPart : SKShapeNode {
    
    let SNAKE_DIAMETR : CGFloat = 10.0
    
    init(atPoint point : CGPoint){
        super.init()
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: SNAKE_DIAMETR, height: SNAKE_DIAMETR)).cgPath
        fillColor = UIColor.green
        strokeColor = UIColor.green
        lineWidth = 1
        
        self.position = point
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: SNAKE_DIAMETR - 4.0, center: CGPoint(x: 5, y: 5))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = CollisionCategories.Snake
        
        self.physicsBody?.contactTestBitMask = CollisionCategories.EdgeBody | CollisionCategories.Apple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
