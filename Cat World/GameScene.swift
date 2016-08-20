//
//  GameScene.swift
//  Meow Town
//
//  Created by Willis Allstead on 4/7/16.
//  Copyright (c) 2016 Willis Allstead. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var world: World?
    var catCam: CatCam!
    var scale: CGFloat!
    var defaultData: Plist?
    
    // MARK: Scene Setup
    
    override init() {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        let h = min(width, height)
        let w = max(width, height)
        super.init(size: CGSize(width: w, height: h))
        
        GameScene.current = self
        
        if let path = Bundle.main.path(forResource: "defaultdata", ofType: "plist") {
            defaultData = Plist(path: path)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var current: GameScene! = nil
    
    
    // MARK: Presenting Scene
    
    override func didMove(to view: SKView) {
        
        /* Framing the camera */
        
        catCam = CatCam(withFrame: CGRect(x: -self.frame.width/2, y: -self.frame.height/2, width: self.frame.width, height: self.frame.height))
        catCam.position = self.frame.mid()
        catCam.zPosition = 9999999
        self.camera = catCam
        self.addChild(catCam)
        
        /* Making the world */
        
        var filePath : String? {
            let manager = FileManager.default
            let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
            return url?.appendingPathComponent("worldData").path
        }
        
        if filePath != nil {
            if let loadedWorld = NSKeyedUnarchiver.unarchiveObject(withFile: filePath!) as? World {
                world = loadedWorld
                print("[GameScene] Loaded \(world!)")
            } else {
                print("[GameScene] Couldn't load world 😕.")
                let newWorld = World(name: "worldy")
                world = newWorld
                if NSKeyedArchiver.archiveRootObject(newWorld, toFile: filePath!) {
                    print("[GameScene] Saved \(world!)")
                } else {
                    print("[GameScene] Failed to save \(world!)")
                }
            }
        } else {
            print("[GameScene] Filepath is nil.")
        }
    
        if world != nil {
            world!.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            world!.zPosition = 0
            
            let worldEffectNode = SKEffectNode() // Can add effects to this node
            worldEffectNode.addChild(world!)
            addChild(worldEffectNode)
        }
    }
   
    override func update(_ currentTime: CFTimeInterval) {
//        world.update(currentTime: currentTime)
        catCam.update(currentTime: currentTime)
    }
    
    
    
    // MARK: Purchasing
    
//    func attemptPurchase(withData data: NSMutableDictionary) -> Bool {
//        let storeDict = PlistManager.sharedInstance.getValueForKey(key: "Store") as! NSMutableDictionary
//        let categoriesDict = storeDict.value(forKey: "Categories") as! NSMutableDictionary
//        let foodsDict = categoriesDict.value(forKey: "Foods") as! NSMutableDictionary
//        for value in foodsDict.allValues {
//            if data == value as! NSMutableDictionary {
//                let mutableValue = value as! NSMutableDictionary
//                let infoDict = mutableValue.value(forKey: "info") as! NSDictionary
//                let price = infoDict.value(forKey: "price") as! Int
//                if world.score - price >= 0 {
//                    world.score = world.score - price
//                    GameScene.current.catCam.updateScore(score: world.score)
//                    print("score: \(world.score)")
//                } else {
//                    return false
//                }
//                
//                mutableValue.setValue(true, forKey: "owned")
//                PlistManager.sharedInstance.saveValue(value: storeDict, forKey: "Store")
//                return true
//            }
//        }
//        return false // if it makes it here there was an error
//    }
//    
//    func toggleEnable(withData data: NSMutableDictionary) -> Bool {
//        let storeDict = PlistManager.sharedInstance.getValueForKey(key: "Store") as! NSMutableDictionary
//        let categoriesDict = storeDict.value(forKey: "Categories") as! NSMutableDictionary
//        let foodsDict = categoriesDict.value(forKey: "Foods") as! NSMutableDictionary
//        for value in foodsDict.allValues {
//            if data == value as! NSMutableDictionary {
//                let mutableValue = value as! NSMutableDictionary
//                var enabledState = mutableValue.value(forKey: "enabled") as! Bool
//                enabledState.toggle()
//                mutableValue.setValue(enabledState, forKey: "enabled")
//                PlistManager.sharedInstance.saveValue(value: storeDict, forKey: "Store")
//                return true
//            }
//        }
//        return false // if it makes it here there was an error
//    }
    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

