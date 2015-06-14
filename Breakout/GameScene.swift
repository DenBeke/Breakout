//
//  GameScene.swift
//  Breakout
//
//  Created by Mathias Beke on 13/06/15.
//  Copyright (c) 2015 DenBeke. All rights reserved.
//

import SpriteKit
import CoreMotion

let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let BlockCategoryName = "block"
let BlockNodeCategoryName = "blockNode"

let BallCategory   : UInt32 = 0x1 << 0 // 00000000000000000000000000000001
let BottomCategory : UInt32 = 0x1 << 1 // 00000000000000000000000000000010
let BlockCategory  : UInt32 = 0x1 << 2 // 00000000000000000000000000000100
let PaddleCategory : UInt32 = 0x1 << 3 // 00000000000000000000000000001000

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var isFingerOnPaddle = false
    let motionManager: CMMotionManager = CMMotionManager()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        /*
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
        */
        
        // Create a physics body that borders the screen
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        // Set the friction of that physicsBody to 0
        borderBody.friction = 0
        // Set physicsBody of scene to borderBody
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        let ball = childNodeWithName(BallCategoryName) as! SKSpriteNode
        ball.physicsBody!.applyImpulse(CGVectorMake(10, -10))
        
        let bottomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        addChild(bottom)
        
        let paddle = childNodeWithName(PaddleCategoryName) as! SKSpriteNode
        
        bottom.physicsBody!.categoryBitMask = BottomCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        paddle.physicsBody!.categoryBitMask = PaddleCategory

        ball.physicsBody!.contactTestBitMask = BottomCategory
        
        //motionManager.startAccelerometerUpdates()
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Check if touch is on paddle
        let touch = touches.first!
        let touchLocation = touch.locationInNode(self)
        
        if let body = physicsWorld.bodyAtPoint(touchLocation) {
            if body.node!.name == PaddleCategoryName {
                print("Began touch on paddle")
                isFingerOnPaddle = true
            }
        }
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Check whether user touched the paddle
        if isFingerOnPaddle {
            // Get touch location
            let touch = touches.first!
            let touchLocation = touch.locationInNode(self)
            let previousLocation = touch.previousLocationInNode(self)
            
            // Get node for paddle
            let paddle = childNodeWithName(PaddleCategoryName) as! SKSpriteNode
            
            // Calculate new position along x for paddle
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            
            // Limit x so that paddle won't leave screen to left or right
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            
            // Update paddle position
            paddle.position = CGPointMake(paddleX, paddle.position.y)
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Removed finger from paddle
        isFingerOnPaddle = false
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        // Create local variables for two physics bodies
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // react to the contact between ball and bottom
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
            // Display of Game Over Scene
            if let mainView = view {
                let gameOverScene = GameOverScene(fileNamed: "GameOverScene")
                gameOverScene!.size = size
                gameOverScene!.scaleMode = scaleMode
                gameOverScene!.gameWon = false
                mainView.presentScene(gameOverScene)
            }
        }
    }
    
    
}
