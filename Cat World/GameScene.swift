//
//  GameScene.swift
//  Cat World
//
//  Created by Willis Allstead on 4/7/16.
//  Copyright (c) 2016 Willis Allstead. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var oscar: Cat?
    
    override func didMoveToView(view: SKView) {
        
        
        let world = World(inScene: self)
        self.addChild(world)
        
        oscar = Cat(name: "Oscar", skin: "oscar", mood: "happy", weight: 120, inWorld: world)
        oscar!.printInfo()
        
        self.addChild(CatSelect(inScene: self))
        
        oscar!.addActivity(oscar!.flyTo(CGPoint(x: world.floor.frame.midX, y: world.floor.frame.midY)), priority: 1)
        
        
    
                
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      
    }
   
    override func update(currentTime: CFTimeInterval) {
        oscar!.update()
    }
}
