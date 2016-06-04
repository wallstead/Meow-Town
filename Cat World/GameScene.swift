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
