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
        
        let camera = SKCameraNode()
        self.camera = camera;
        camera.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
//        let oscar = Cat(name: "Oscar", skin: "oscar", mood: "happy", weight: 120, inScene: self)
        self.addChild(camera)
        
        self.addChild(CatSelect(inScene: self))
//        
//        let charlie = Cat(name: "Charlie", skin: "oscar", mood: "happy", weight: 120, inScene: self)
//        oscar.familyNode!.addChild(charlie.familyNode!)
//        
//    
//        charlie.addActivity(SKAction.waitForDuration(1), priority: 1)
//        
//       camera.runAction(SKAction.moveByX(100, y: 0, duration: 5))
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      
    }
   
    override func update(currentTime: CFTimeInterval) {
        
    }
}
