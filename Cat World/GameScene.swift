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
    
    
    // MARK: Scene Setup
    
    override init() {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
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
        catCam = CatCam(withFrame: CGRect(x: -self.frame.width/2, y: -self.frame.height/2, width: self.frame.width, height: self.frame.height))
        catCam.position = self.frame.mid()
        catCam.zPosition = 9999999
        self.camera = catCam
        self.addChild(catCam)
        
        print("attempting load!")
        
//        let worldFileName = getDocumentsDirectory().appending("worldData")
        var filePath : String? {
            let manager = FileManager.default
            let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
            return url?.appendingPathComponent("worldData").path
        }
        
        if filePath != nil {
            print("filepath is not nil")
            if let loadedWorld = NSKeyedUnarchiver.unarchiveObject(withFile: filePath!) as? World {
                print(loadedWorld)
                print("loaded!")
            } else {
                print("couldn't load!")
                let newWorld = World(name: "worldo")
                print("saving new world!")
                if NSKeyedArchiver.archiveRootObject(newWorld, toFile: filePath!) {
                    print("saved new world!")
                } else {
                    print("failed to save new world!")
                }
}
        } else {
            print("filepath is nil")
        }
        
        
//        if let loadedWorld = NSKeyedUnarchiver.unarchiveObject(withFile: worldFileName) as! World? {
//            print("loaded!")
//        } else {
//            print("couldn't load!")
//            print("creating new world!")
//            let newWorld = World(name: "worldo")
//            print("saving new world!")
//            let data = NSKeyedArchiver.archivedData(withRootObject: newWorld)
//            print(data)
//            if NSKeyedArchiver.archiveRootObject(newWorld, toFile: worldFileName) {
//                print("saved new world!")
//            } else {
//                print("failed to save new world!")
//            }
//        }
        
        
        
        
//        let worldData = PlistManager.sharedInstance.getValueForKey(key: "World") as! Data
//        if worldData.count != 0 { // if not empty
//            let loadedWorld = NSKeyedUnarchiver.unarchiveObject(with: worldData) as! World
//            print(loadedWorld)
//            world = loadedWorld
//        } else {
//            world = World(name: "world")
//            world.save()
//        }
//        world.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
//        world.zPosition = 0
        
//        let worldEffectNode = SKEffectNode()
//        worldEffectNode.addChild(world)
//        worldEffectNode.shouldEnableEffects = true
//        let newfilter = CIFilter(name: "CIColorMonochrome")
        
        
//        var scaleCounter = 0.0
//        
//        
//        
//        let changeFilter = SKAction.run({
//            let newfilter = CIFilter(name: "CIVignetteEffect", options: )
////            worldEffectNode.shouldCenterFilter = false
//            
//            newfilter?.setValue(CIVector(x: 400, y: 150), forKey: kCIInputCenterKey)
//            print(newfilter?.value(forKey: kCIInputCenterKey))
//            
//            newfilter?.setValue(900, forKey: kCIInputRadiusKey)
//            newfilter?.setValue(0.2, forKey: kCIInputIntensityKey)
//            worldEffectNode.filter = newfilter
//            scaleCounter += 0.1
//        })
//        
//        let wait = SKAction.wait(forDuration: 0.1)
//        
//        let animateFilter = SKAction.repeat(SKAction.sequence([changeFilter, wait]), count: 20)
//        
//     
//        worldEffectNode.run(animateFilter)
        
//        self.addChild(worldEffectNode)
//        CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
//        [blurFilter setValue:@10.0 forKey:kCIInputRadiusKey];
        
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

