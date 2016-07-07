//
//  GameScene.swift
//  drawing
//
//  Created by synaptics on 7/6/16.
//  Copyright (c) 2016 Amino. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var touch : UITouch!
    var lastPoint : CGPoint!
    var currentPoint : CGPoint!

    var path : CGMutablePath! = nil
    
    var paths = [SKShapeNode]()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 150, 135)
        CGPathAddLineToPoint(path, nil, 430, 135)
        let shape = SKShapeNode()
        shape.path = path
        shape.physicsBody?.collisionBitMask = UINT32_MAX
        shape.physicsBody?.contactTestBitMask = 0
        shape.physicsBody?.categoryBitMask = UINT32_MAX
        shape.physicsBody?.fieldBitMask = UINT32_MAX
        addChild(shape)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if paths.count > 0{
            removeChildrenInArray(paths)
        }
        path = CGPathCreateMutable()
        touch = touches.first
        lastPoint = touch.locationInNode(self)
        //print(lastPoint)
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
        shape.physicsBody?.contactTestBitMask = 1
        shape.physicsBody?.affectedByGravity = true
        shape.physicsBody?.dynamic = true
        shape.physicsBody?.allowsRotation = true
        addChild(shape)
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
