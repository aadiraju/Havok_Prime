//Double Jump
//  GameScene.swift
//  Solo Missions
//
//  Created by Gamer on 25/03/17.
//  Copyright © 2017 Dev5. All rights reserved.
//

import SpriteKit
import GameplayKit
let player = SKSpriteNode(imageNamed: "front")
let stage = SKSpriteNode(imageNamed: "Basic Stage")
let square = SKSpriteNode(imageNamed: "sq")
let circ = SKSpriteNode(imageNamed: "Circle")
let jbut = SKSpriteNode(imageNamed: "Jump")
let abut = SKSpriteNode(imageNamed: "A")
let playerl = SKSpriteNode(imageNamed: "front_leftfacing")

class GameScene: SKScene, SKPhysicsContactDelegate
{
    
    var gameArea = CGRect()
    
    struct PhysicsCategories
    {
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b10 //1
        static let Stage : UInt32 = 0b100
        static let Proj : UInt32 = 0b1000
    }
    
    var isFire = false
    
    func random() -> CGFloat
    {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat
    {
        return random() * (max-min) + min
    }
    
    var contactsp = false
    
    override func didMove(to view: SKView)
    {
        
        let background = SKSpriteNode(imageNamed: "Background-1")
        background.size = self.size
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = 0;
        self.addChild(background)
        
        physicsWorld.contactDelegate = self
        
        player.setScale(1.2)
        player.position = CGPoint(x: 0, y: 125)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = contactsp
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.Stage
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Stage
        self.addChild(player)
        
        let playerl = player.copy() as! SKSpriteNode
        playerl.position.x = 10000
        
        stage.setScale(1.2)
        stage.position = CGPoint(x: 0, y: 0)
        stage.zPosition = 2
        stage.physicsBody = SKPhysicsBody(rectangleOf: stage.size)
        stage.physicsBody!.affectedByGravity = false
        stage.physicsBody!.categoryBitMask = PhysicsCategories.Stage
        stage.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        stage.physicsBody!.isDynamic = false
        self.addChild(stage)
        
        square.setScale(0.3)
        square.position = CGPoint(x: -250, y:-500)
        square.zPosition = 1
        self.addChild(square)
        
        circ.setScale(0.1)
        circ.position = CGPoint(x: -250, y:-500)
        circ.zPosition = 2
        self.addChild(circ)
        
        jbut.setScale(1)
        jbut.position = CGPoint(x: 250, y:-500)
        jbut.zPosition = 2
        self.addChild(jbut)
        
        abut.setScale(0.6)
        abut.position = CGPoint(x: 250, y:-300)
        abut.zPosition = 2
        self.addChild(abut)
        
    }
    
    var bulletDirection = 1
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch: AnyObject in touches
        {
            let pointOfTouch = touch.location(in: self)
            if pointOfTouch.x < (-250 + square.size.width/2) && pointOfTouch.x > (-250 - square.size.width/2) && pointOfTouch.y < (-500 + square.size.height/2) && pointOfTouch.y > (-500 - square.size.height/2)
            {
                
                let previousPointOfTouch = touch.previousLocation(in: self)
                let amountDraggedx = pointOfTouch.x - previousPointOfTouch.x
                
                //Correction to make image flip
                if( previousPointOfTouch.x > -250 && pointOfTouch.x <= -250)
                {
                    player.xScale = -1.0
                    bulletDirection = -1
                }
                
                if( previousPointOfTouch.x < -250 && pointOfTouch.x >= -250)
                {
                    player.xScale = 1.0
                    bulletDirection = 1
                }
                
                circ.position.x += amountDraggedx
                dur=20
                moveguyx()
                if player.position.x > stage.size.width/2 || player.position.x < -stage.size.width/2
                {
                    player.physicsBody!.affectedByGravity = true
                }
                
                if circ.position.x > (-250 + square.size.width/2 - circ.size.width/2)
                {
                    circ.position.x = (-250 + square.size.width/2 - circ.size.width/2)
                }
                
                if circ.position.x < (-250 - square.size.width/2 + circ.size.width/2)
                {
                    circ.position.x = (-250 - square.size.width/2 + circ.size.width/2)
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        circ.position.x = -250
        circ.position.y = -500
        dur=100000
        
        moveguyx()
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else
        {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Stage
        {
            jumpcount = 2
            downtime = 0.75
        }
        else
        {
            jumpcount = 2
            downtime = 0.75
        }
    }
    
    var jumpcount = 2
    var downtime = 0.75
    func jumpguy()
    {
        if (jumpcount > 0)
        {
            let moveUp = SKAction.moveTo(y: player.position.y + 160, duration: 0.75)
            let moveDown = SKAction.moveTo(y: 40 , duration: downtime)
            let moveSequence=SKAction.sequence([moveUp, moveDown])
            player.run(moveSequence)
            jumpcount = jumpcount - 1
            downtime = downtime + 0.75
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        for touch: AnyObject in touches
        {
            
            let pointOfTouch = touch.location(in: self)
            
            if pointOfTouch.x < (250 + jbut.size.width/2) && pointOfTouch.x > (250 - jbut.size.width/2) && pointOfTouch.y < (-500 + jbut.size.height/2) && pointOfTouch.y > (-500 - jbut.size.height/2)
            {
                jumpguy()
            }
            
            if pointOfTouch.x < (250 + abut.size.width/2) && pointOfTouch.x > (250 - abut.size.width/2) && pointOfTouch.y < (-300 + abut.size.height/2) && pointOfTouch.y > (-300 - abut.size.height/2)
            {
                moveProj()
            }
            
        }
        
    }
    
    func moveProj()
    {
        let proj = SKSpriteNode(imageNamed: "Projectile")
        proj.setScale(1)
        proj.position = CGPoint(x: player.position.x, y:player.position.y+10)
        proj.zPosition = 1
        proj.physicsBody = SKPhysicsBody(rectangleOf: proj.size)
        proj.physicsBody!.affectedByGravity = false
        proj.physicsBody!.categoryBitMask = PhysicsCategories.Proj
        proj.physicsBody!.collisionBitMask = PhysicsCategories.None
        self.addChild(proj)
        var moveproj = SKAction.moveTo(x: player.position.x + 10000, duration: 25)
        
        if (bulletDirection==1)
        {
            moveproj = SKAction.moveTo(x: player.position.x + 10000, duration: 25)
        }
        else
        {
            moveproj = SKAction.moveTo(x: player.position.x - 10000, duration: 25)
        }
        
        let deleteproj=SKAction.removeFromParent()
        let moveSequence=SKAction.sequence([moveproj, deleteproj])
        proj.run(moveSequence)
    }
    
    func moveguyx()
    {
        let moveGuy = SKAction.moveTo(x: player.position.x + (circ.position.x+250)*30, duration: dur)
        let moveSequence=SKAction.sequence([moveGuy])
        player.run(moveSequence)
    }
    
    var dur = 20.0;
}
