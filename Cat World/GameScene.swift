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
        
        
        self.addChild(world)
        
        
//        let oscar = Cat(name: "Oscar", skin: "oscar", mood: "happy", weight: 120, inWorld: world)
//        oscar.addActivity(oscar.flyTo(CGPoint(x: world.floor.frame.midX, y: world.floor.frame.midY)), priority: 1)
//        
       
    }
    
    class func displayCatSelection(inScene scene: SKScene) {
        let catSelection = CatSelect(inScene: scene)
        scene.addChild(catSelection)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      
    }
   
    override func update(currentTime: CFTimeInterval) {
        world.update()
    }
}
