//
//  GameScene.swift
//  Cat World
//
//  Created by Willis Allstead on 4/7/16.
//  Copyright (c) 2016 Willis Allstead. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        
        let cat = Cat(name: "Fred", skin: "oscar", mood: "happy", weight: 120, inScene: self)
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock({
//            cat.trackAge()
//            cat.printInfo()
            cat.doThings()
        }), SKAction.waitForDuration(1.0)])))
        cat.addActivity(SKAction.waitForDuration(1), priority: 1)
        
        runAction(SKAction.sequence([SKAction.waitForDuration(0.5),SKAction.runBlock({
            cat.addActivity(SKAction.waitForDuration(1), priority: 2)
            cat.addActivity(SKAction.scaleBy(2, duration: 2), priority: 5)
            cat.addActivity(SKAction.moveByX(10, y: 0, duration: 1), priority: 1)
        })]))
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      
    }
   
    override func update(currentTime: CFTimeInterval) {
        
    }
}
