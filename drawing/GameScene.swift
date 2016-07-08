//
//  GameScene.swift
//  drawing
//
//  Created by synaptics on 7/6/16.
//  Copyright (c) 2016 Amino. All rights reserved.
//

import SpriteKit

class GameScene: SKScene , SKPhysicsContactDelegate{
    
    enum state{
        case playing, ended
    }
    
    var touch : UITouch!
    var lastPoint : CGPoint!
    var currentPoint : CGPoint!

    var path : CGMutablePath! = nil
    
    var paths = [SKShapeNode]()
    var count = 0
    
    var square : SKSpriteNode!
    var jumpButton : MSButtonNode!
    var restartButton : MSButtonNode!
    var goal : SKSpriteNode!
    
    var currentState:state = .playing
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        physicsWorld.contactDelegate = self
        
        square = childNodeWithName("square") as! SKSpriteNode
        jumpButton = childNodeWithName("jump") as! MSButtonNode
        jumpButton.selectedHandler = {
            if self.currentState == .ended {return}
            self.square.physicsBody?.velocity = CGVectorMake(0, 0)
            self.square.physicsBody?.applyImpulse(CGVectorMake(0, 40))
        }
        
        restartButton = childNodeWithName("restartButton") as! MSButtonNode
        restartButton.selectedHandler = {
            self.removeChildrenInArray(self.paths)
            self.paths.removeAll()
            self.count = 0
            
            self.childNodeWithName("square")?.position = CGPoint(x: 66, y: 65)
            self.restartButton.state = .Hidden
            
        }
        
        goal = childNodeWithName("goal") as! SKSpriteNode
        
        restartButton.state = .Hidden
        
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if currentState != .playing {return}
        
        if count > 3{
            removeChildrenInArray(paths)
            count = 0
        }
        count += 1
        path = CGPathCreateMutable()
        touch = touches.first
        lastPoint = touch.locationInNode(self)
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if currentState != .playing {return}

        touch = touches.first
        currentPoint = lastPoint
        lastPoint = touch.locationInNode(self)
        drawRect()
    }
    
    func drawRect(){

        CGPathMoveToPoint(path, nil, lastPoint.x, lastPoint.y)
        CGPathAddLineToPoint(path, nil, currentPoint.x, currentPoint.y)
        
        let shape = SKShapeNode()
        shape.path = path
        shape.strokeColor = UIColor.blackColor()
        shape.lineWidth = 2
        paths.append(shape)
        shape.physicsBody = SKPhysicsBody(edgeFromPoint: currentPoint, toPoint: lastPoint)
        addChild(shape)
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact){
        
        if currentState != .playing {return}
        
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        if nodeA.name == "goal" || nodeB.name == "goal" {
           currentState = .ended
           restartButton.state = .Active
            goal.runAction(SKAction(named: "Winning")!)
        }
        
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
