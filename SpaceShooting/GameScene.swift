//
//  GameScene.swift
//  SpaceShooting
//
//  Created by 長野貴之 on 2019/08/29.
//  Copyright © 2019 takayuki Nagano. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var hearts: [SKSpriteNode] = []
    
    var scoreLabel:SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var gameTimer: Timer!
    
    var possibleEnemy = ["enemy1", "enemy2", "enemy3"]
    
    let playershipCategory: UInt32 = 0b0001
    let photonTorpedoCategory: UInt32 = 0b0010
    let enemyCategory: UInt32 = 0b0100
    
    override func didMove(to view: SKView) {
        
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: self.frame.width / 2, y: self.frame.height)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "playership")
        player.scale(to: CGSize(width: frame.width / 6, height: frame.width / 6))
        player.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 4)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.width * 0.1)
        player.physicsBody?.categoryBitMask = playershipCategory
        player.physicsBody?.contactTestBitMask = photonTorpedoCategory
        player.physicsBody?.collisionBitMask = 0
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: self.frame.width / 5 ,
                                      y: self.frame.height - scoreLabel.frame.height * 5 - 35)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        score = 0
        self.addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(AddEnemy),
                                         userInfo: nil, repeats: true)
        
        for i in 1...5 {
            let heart = SKSpriteNode(imageNamed: "heart")
            heart.position = CGPoint(x: 10 + heart.frame.height * CGFloat(i),
                                     y: frame.height - heart.frame.height - 7)
            addChild(heart)
            hearts.append(heart)
        }
        
    }
    
    @objc func AddEnemy() {
        let index = Int(arc4random_uniform(UInt32(possibleEnemy.count)))
        let name = possibleEnemy[index]
        let enemy = SKSpriteNode(imageNamed: name)
        let random = CGFloat(arc4random_uniform(UINT32_MAX)) / CGFloat(UINT32_MAX)
        let posotionX = frame.width * (random + 0.1)
        enemy.position = CGPoint(x: posotionX, y: frame.height + enemy.frame.height)
        enemy.scale(to: CGSize(width: 70, height: 70))
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.frame.width)
        enemy.physicsBody?.categoryBitMask = enemyCategory
        enemy.physicsBody?.contactTestBitMask = photonTorpedoCategory + playershipCategory
        enemy.physicsBody?.collisionBitMask = 0
        addChild(enemy)
        
        let move = SKAction.moveTo(y: -frame.height / 2 - enemy.frame.height, duration: 6.0)
        let remove = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([move,remove]))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            player.position = touchLocation
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            player.position = touchLocation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        let torpedoNode = SKSpriteNode(imageNamed: "missile")
        torpedoNode.position = CGPoint(x: self.player.position.x, y: player.position.y + 40)
        addChild(torpedoNode)
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.frame.height / 2)
        torpedoNode.physicsBody?.categoryBitMask = photonTorpedoCategory
        torpedoNode.physicsBody?.contactTestBitMask = enemyCategory
        torpedoNode.physicsBody?.collisionBitMask = 0
        
        let moveToTop = SKAction.moveTo(y: frame.height + 10, duration: 0.3)
        let remove = SKAction.removeFromParent()
        torpedoNode.run(SKAction.sequence([moveToTop, remove]))
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var enemy: SKPhysicsBody
        var target: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == enemyCategory {
            enemy = contact.bodyA
            target = contact.bodyB
        } else {
            enemy = contact.bodyB
            target = contact.bodyA
        }
        
        guard let enemyNode = enemy.node else {return}
        guard let targetNode = target.node else {return}
        guard let explosion = SKEmitterNode(fileNamed: "Explosion1") else {return}
        explosion.position = enemyNode.position
        addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("enemybomb.mp3", waitForCompletion: false))
        
        enemyNode.removeFromParent()
        
        if target.categoryBitMask == photonTorpedoCategory {
            targetNode.removeFromParent()
            score += 5
        }
        
        self.run(SKAction.wait(forDuration: 1.0)) {
            explosion.removeFromParent()
        }
        
        if target.categoryBitMask == playershipCategory {
            guard let heart = hearts.last else {return}
            heart.removeFromParent()
            hearts.removeLast()
            if hearts.isEmpty {
                gameover()
            }
        }
    }
    
    func gameover() {
        
        let transition = SKTransition.flipHorizontal(withDuration: 1.0)
        let scene = GameOverScene()
        scene.scaleMode = .aspectFill
        scene.size = self.size
        self.view?.presentScene(scene, transition:  transition)

    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
