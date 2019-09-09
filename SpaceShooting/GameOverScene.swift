//
//  GameOverScene.swift
//  SpaceShooting
//
//  Created by 長野貴之 on 2019/08/29.
//  Copyright © 2019 takayuki Nagano. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    var title: SKLabelNode!
    var newgameButton: SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        //「GameOver」の表示
        title = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        title.fontSize = 80
        title.text = "Game Over..."
        title.position = CGPoint(x: self.frame.width / 2, y: self.frame.height * 3/4)
        self.addChild(title)
        
        //ゲームを再スタートするボタン
        newgameButton = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        newgameButton.text = "Continue"
        newgameButton.fontSize = 55
        newgameButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        newgameButton.name = "newgameButton"
        self.addChild(newgameButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "newgameButton" {
                let transition = SKTransition.flipVertical(withDuration: 0.5)
                let gamescene = GameScene(size: self.size)
                self.view?.presentScene(gamescene, transition: transition)
                
            }
        }
    }
}

