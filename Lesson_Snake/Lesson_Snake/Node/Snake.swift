//
//  Snake.swift
//  Lesson_Snake
//
//  Created by Glumer Glumer on 14.06.2020.
//  Copyright © 2020 UCG. All rights reserved.
//

import UIKit
import SpriteKit

class Snake : SKShapeNode {
    var moveSpeed : CGFloat = 125.0
    var body = [SnakeBodyPart]()
    var angle : CGFloat = 0.0
    
    convenience init(atPoint point: CGPoint){
        self.init()
        
        let head = SnakeHead(atPoint: point)
        body.append(head)
        addChild(head)
    }
    
    func move() {
        guard !body.isEmpty else {
            return
        }
        
        guard moveSpeed > 0 else {
            return
        }
        
        let head = body[0]
        moveHead(head)
        
        for index in (0..<body.count) where index > 0 {
            let prevBodyPart = body[index - 1]
            let curBodyPart = body[index]
            moveBodyPart(prevBodyPart, c: curBodyPart)
        }
    }
    
    func decreaseSize() {
        while body.count > 1 {
            body[body.count - 1].removeFromParent()
            body.removeLast()
        }
    }
    
    func moveTo(atPoint point: CGPoint){
        body[0].position = point
    }
    
    func moveHead(_ head : SnakeBodyPart) {
        let dx = moveSpeed * sin(angle)
        let dy = moveSpeed * cos(angle)
        
        let nextPosition = CGPoint(x: head.position.x + dx, y: head.position.y + dy)
        
        let moveAction = SKAction.move(to: nextPosition, duration: 1.0)
        head.run(moveAction)
    }
    
    func moveBodyPart(_ p: SnakeBodyPart, c: SnakeBodyPart) {
        let moveAction = SKAction.move(to: CGPoint(x: p.position.x, y: p.position.y), duration: 0.1)
        c.run(moveAction)
    }
    
    func addBodyPart() {
        let newBodyPart = SnakeBodyPart(atPoint: CGPoint(x: body[0].position.x, y: body[0].position.y))
        body.append(newBodyPart)
        addChild(newBodyPart)
    }
    
    func moveLeft() {
        angle += CGFloat(Double.pi / 2)
    }
    
    func moveRight() {
        angle -= CGFloat(Double.pi / 2)
    }
    
    func stop() {
        moveSpeed = 0.0
    }
    
    func startMove() {
        moveSpeed = 125.0
    }
}
