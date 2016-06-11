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
    var catCam: CatCam!
    
    override init() {
        let width = UIScreen.mainScreen().bounds.width
        let height = UIScreen.mainScreen().bounds.height
        
        print("width: \(width), height: \(height)")
        
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
        
        catCam = CatCam(withFrame: CGRect(x: -self.frame.width/2, y: -self.frame.height/2, width: self.frame.width, height: self.frame.height)) // This frame to offset the camera being centered 
        self.camera = catCam
        catCam.position = self.frame.mid()
        catCam.zPosition = 9999999
        
        self.addChild(catCam)
        
        let worldData = PlistManager.sharedInstance.getValueForKey("World") as? NSData
        
        if worldData?.length != 0 { // check if empty
            let loadedWorld = NSKeyedUnarchiver.unarchiveObjectWithData(worldData!) as? World
            world = loadedWorld
        } else {
            world = World(name: "world")
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
        catCam.update(currentTime)
    }
}


extension SKNode {
    
    var frameInScene:CGRect {
        get {
            if let scene = self.scene {
                if let parent = self.parent {
                    let rectOriginInScene = scene.convertPoint(self.frame.origin, fromNode: parent)
                    return CGRect(origin: rectOriginInScene, size: self.frame.size)
                }
            }
            return frame
        }
    }
    
    var positionInScene:CGPoint {
        get {
            if let scene = self.scene {
                if let parent = self.parent {
                    return scene.convertPoint(self.position, fromNode: parent)
                }
            }
            
            return position
        }
    }
}
