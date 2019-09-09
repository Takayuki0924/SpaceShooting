//
//  TitleScene.swift
//  SpaceShooting
//
//  Created by 長野貴之 on 2019/08/29.
//  Copyright © 2019 takayuki Nagano. All rights reserved.
//

import SpriteKit

class TitleScene: SKScene {
    //ゲーム画面に遷移する
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "StartButton" {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gamescene = GameScene(size: self.size)
                self.view?.presentScene(gamescene, transition: transition)
            }
        }
        
    }
}
