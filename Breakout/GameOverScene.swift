//
//  GameOverScene.swift
//  Breakout
//
//  Created by Mathias Beke on 14/06/15.
//  Copyright © 2015 DenBeke. All rights reserved.
//

import SpriteKit

let GameOverLabelCategoryName = "gameOverLabel"

class GameOverScene: SKScene {
    var gameWon : Bool = false {
        didSet {
            let gameOverLabel = childNodeWithName(GameOverLabelCategoryName) as! SKLabelNode
            gameOverLabel.text = gameWon ? "Game Won" : "Game Over"
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let view = view {
            let gameScene = GameScene(fileNamed: "GameScene")
            gameScene!.size = size
            gameScene!.scaleMode = scaleMode
            view.presentScene(gameScene)
        }
    }
}
