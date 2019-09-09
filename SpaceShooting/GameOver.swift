//
//  GameOver.swift
//  SpaceShooting
//
//  Created by 長野貴之 on 2019/08/29.
//  Copyright © 2019 takayuki Nagano. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        //この画面のタイトル
        let myLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        myLabel.text = "GameOver"
        myLabel.fontSize = 80
        myLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height * 2/3)
        
        self.addChild(myLabel)
        
        //タイトル画面へ
        let toTitleLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        toTitleLabel.text = "タイトル画面へ"
        toTitleLabel.fontSize = 45
        toTitleLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 4 - 40)
        toTitleLabel.name = "タイトル画面へ"
        self.addChild(toTitleLabel)
        
        
    }
}
