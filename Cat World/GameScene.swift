//
//  GameScene.swift
//  Cat World
//
//  Created by Willis Allstead on 4/7/16.
//  Copyright (c) 2016 Willis Allstead. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var world: World!
    
    override func didMoveToView(view: SKView) {
        
        world = World(inScene: self)
        let catSelection = CatSelect(inScene: self)
        
        self.addChild(world)
        self.addChild(catSelection)
        
        let oscar = Cat(name: "Oscar", skin: "oscar", mood: "happy", weight: 120, inWorld: world)
        oscar.printInfo()
        oscar.addActivity(oscar.flyTo(CGPoint(x: world.floor.frame.midX, y: world.floor.frame.midY)), priority: 1)
        
       
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      
    }
   
    override func update(currentTime: CFTimeInterval) {
        world.update()
    }
}
