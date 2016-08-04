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
    var scale: CGFloat!
    
    override init() {
        let width = UIScreen.main().bounds.width
        let height = UIScreen.main().bounds.height
        
        let h = min(width, height)
        let w = max(width, height)
        super.init(size: CGSize(width: w, height: h))
        
        GameScene.current = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var current: GameScene! = nil
    
    override func didMove(to view: SKView) {
        
       
        
        catCam = CatCam(withFrame: CGRect(x: -self.frame.width/2, y: -self.frame.height/2, width: self.frame.width, height: self.frame.height)) // This frame to offset the camera being centered 
        self.camera = catCam
        catCam.position = self.frame.mid()
        catCam.zPosition = 9999999
        
        self.addChild(catCam)
        
        let worldData = PlistManager.sharedInstance.getValueForKey(key: "World") as! Data
        
        if worldData.count != 0 { // check if empty
            let loadedWorld = NSKeyedUnarchiver.unarchiveObject(with: worldData) as! World
            print(loadedWorld)
            world = loadedWorld
        } else {
            world = World(name: "world")
        }
        
        world.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        world.zPosition = 0
        
        self.addChild(world)
        
        world.save()
        
        
    }
   
    override func update(_ currentTime: CFTimeInterval) {
        world.update(currentTime: currentTime)
        catCam.update(currentTime: currentTime)
    }
    
    func attemptPurchase(withData data: NSMutableDictionary) -> Bool {
        let storeDict = PlistManager.sharedInstance.getValueForKey(key: "Store") as! NSMutableDictionary
        let categoriesDict = storeDict.value(forKey: "Categories") as! NSMutableDictionary
        let foodsDict = categoriesDict.value(forKey: "Foods") as! NSMutableDictionary
        for value in foodsDict.allValues {
            if data == value as! NSMutableDictionary {
                let mutableValue = value as! NSMutableDictionary
                let infoDict = mutableValue.value(forKey: "info") as! NSDictionary
                let price = infoDict.value(forKey: "price") as! Int
                if world.score - price >= 0 {
                    world.score = world.score - price
                    GameScene.current.catCam.updateScore(score: world.score)
                    print("score: \(world.score)")
                } else {
                    return false // not enough funds somehow
                }
                
               
                mutableValue.setValue(true, forKey: "owned")
                PlistManager.sharedInstance.saveValue(value: storeDict, forKey: "Store")
                return true
            }
        }
        return false // if it makes it here there was an error
    }
}


extension SKNode {
    
    var frameInScene:CGRect {
        get {
            if let scene = self.scene {
                if let parent = self.parent {
                    let rectOriginInScene = scene.convert(self.frame.origin, from: parent)
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
                    return scene.convert(self.position, from: parent)
                }
            }
            
            return position
        }
    }
}
