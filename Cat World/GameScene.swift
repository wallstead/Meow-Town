//
//  GameScene.swift
//  Cat World
//
//  Created by Willis Allstead on 4/7/16.
//  Copyright (c) 2016 Willis Allstead. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var world: NewWorld!
    
    override init() {
        let width = UIScreen.mainScreen().bounds.width
        let height = UIScreen.mainScreen().bounds.height
        
        let h = min(width, height)
        let w = max(width, height)
        super.init(size: CGSizeMake(w, h))
        
        GameScene.current = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var current: GameScene! = nil
    
    override func didMoveToView(view: SKView) {
        
        // set scheduled events
        
        let worldData = PlistManager.sharedInstance.getValueForKey("World") as? NSData
        
        if worldData?.length != 0 { // check if empty
            let loadedWorld = NSKeyedUnarchiver.unarchiveObjectWithData(worldData!) as? NewWorld
            world = loadedWorld
        } else {
            world = NewWorld(name: "world")
        }
        
        world.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        world.zPosition = 0
        self.addChild(world)
        world.save()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      
    }
   
    override func update(currentTime: CFTimeInterval) {
        world.update(currentTime)
    }
}
