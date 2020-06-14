//
//  GameScene.swift
//  Lesson_Snake
//
//  Created by Glumer Glumer on 10.06.2020.
//  Copyright © 2020 UCG. All rights reserved.
//

import SpriteKit
import GameplayKit

struct CollisionCategories {
    static let Snake: UInt32 = 0x1 << 0
    static let SnakeHead: UInt32 = 0x1 << 1
    static let Apple: UInt32 = 0x1 << 2
    static let EdgeBody: UInt32 = 0x1 << 3
}

class GameScene: SKScene {
    let BUTTON_RADIUS : CGFloat = 45.0
    let BUTTON_POSITION_BOTTOM : CGFloat = 45.0
    var snake : Snake?
    var scoreCount: UInt = 0
    var scoreLabel : UILabel! = nil
    var endGameLabel : UILabel! = nil
    var restartButton : UIButton! = nil
    
    override func didMove(to view: SKView) {
        
        let BUTTON_POSITION_LEFT = BUTTON_RADIUS
        let BUTTON_POSITION_RIGHT : CGFloat = BUTTON_RADIUS * 2.0
        let BUTTON_LINE_WIDTH : CGFloat = 5
        
        scoreCount = 0
        
        backgroundColor = SKColor.black
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.allowsRotation = false
        view.showsPhysics = true
        
        self.physicsWorld.contactDelegate = self
        
        let btnLeft = SKShapeNode()
        btnLeft.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: BUTTON_RADIUS, height: BUTTON_RADIUS)).cgPath
        btnLeft.position = CGPoint(x: view.scene!.frame.minX + BUTTON_POSITION_LEFT, y: view.scene!.frame.minY + BUTTON_POSITION_BOTTOM)
        btnLeft.fillColor = UIColor.gray
        btnLeft.strokeColor = UIColor.darkGray
        btnLeft.lineWidth = BUTTON_LINE_WIDTH
        btnLeft.name = "btnLeft"
    
        
        let btnRight = SKShapeNode()
        btnRight.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: BUTTON_RADIUS, height: BUTTON_RADIUS)).cgPath
        btnRight.position = CGPoint(x: view.scene!.frame.maxX - BUTTON_POSITION_RIGHT, y: view.scene!.frame.minY + BUTTON_POSITION_BOTTOM)
        btnRight.fillColor = UIColor.gray
        btnRight.strokeColor = UIColor.darkGray
        btnRight.lineWidth = BUTTON_LINE_WIDTH
        btnRight.name = "btnRight"
        
        scoreLabel = UILabel(frame: CGRect(x:0, y:0, width: BUTTON_RADIUS * 2, height: BUTTON_RADIUS))
        scoreLabel.center = CGPoint(x: view.scene!.frame.maxX / 2, y: view.scene!.frame.maxY - BUTTON_POSITION_BOTTOM)
        scoreLabel.text = String(scoreCount)
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = UIColor.yellow
        
        self.addChild(btnLeft)
        self.addChild(btnRight)
        view.addSubview(scoreLabel)
        
        createApple()
        snake = Snake(atPoint: CGPoint(x: view.scene!.frame.midX, y: view.scene!.frame.midY))
        
        self.addChild(snake!)
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        self.physicsBody?.collisionBitMask = CollisionCategories.Snake | CollisionCategories.SnakeHead
    }
    
    func createApple() {
        let randX = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX - BUTTON_RADIUS)))
        let bottomDelta = BUTTON_POSITION_BOTTOM + BUTTON_RADIUS * 3
        let randY = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY - BUTTON_RADIUS - bottomDelta))) + bottomDelta
        
        let apple = Apple(position: CGPoint(x: randX, y: randY))
        
        self.addChild(apple)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            guard let touchNode = self.atPoint(touchLocation) as? SKShapeNode, touchNode.name == "btnLeft" || touchNode.name == "btnRight" else {
                return
            }
            touchNode.fillColor = .green
            
            if touchNode.name == "btnLeft"{
                snake!.moveLeft()
            } else if touchNode.name == "btnRight" {
                snake!.moveRight()
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            guard let touchNode = self.atPoint(touchLocation) as? SKShapeNode, touchNode.name == "btnLeft" || touchNode.name == "btnRight" else {
                return
            }
            touchNode.fillColor = .gray
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        snake!.move()
    }
    
    @IBAction func startGame() {
        endGameLabel.removeFromSuperview()
        restartButton.removeFromSuperview()
        snake!.decreaseSize()
        snake!.moveTo(atPoint: CGPoint(x: view!.scene!.frame.midX, y: view!.scene!.frame.midY))
        snake!.startMove()
        scoreCount = 0
        scoreLabel.text = String(scoreCount)
    }
    
    func endGame() {
        snake!.stop()
        endGameLabel = UILabel(frame: CGRect(x:0, y:0, width: view!.scene!.frame.maxX, height: BUTTON_RADIUS))
        endGameLabel.center = CGPoint(x: view!.scene!.frame.midX, y: view!.scene!.frame.midY)
        endGameLabel.text = "Игра закончена"
        endGameLabel.textAlignment = .center
        endGameLabel.textColor = UIColor.red
        view?.addSubview(endGameLabel)
        
        restartButton = UIButton(frame: CGRect(x:0, y:0, width: view!.scene!.frame.size.width / 3, height: 30))
        restartButton.titleLabel?.adjustsFontSizeToFitWidth = true
        restartButton.center = CGPoint(x: view!.scene!.frame.midX, y: view!.scene!.frame.midY + 90)
        restartButton.setTitle("Начать заново", for: .normal)
        restartButton.showsTouchWhenHighlighted = true
        restartButton.setTitleColor(UIColor.green, for:  .normal)
        restartButton.addTarget(self, action: #selector(startGame), for: UIControl.Event.touchUpInside)
        view?.addSubview(restartButton)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let bodies = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        let collisionObject = bodies - CollisionCategories.SnakeHead
        
        switch collisionObject {
        case CollisionCategories.Apple:
            let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node
            snake?.addBodyPart()
            apple?.removeFromParent()
            createApple()
            scoreCount += 1
            scoreLabel!.text = String(scoreCount)
        case CollisionCategories.EdgeBody:
            endGame()
        default:
            break;
        }
    }
}
