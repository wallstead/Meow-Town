//
//  World.swift
//  Cat World
//
//  Created by Willis Allstead on 4/29/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

//class World: SKNode {
//    var wallpaper: SKPixelSpriteNode?
//    var floor: SKPixelSpriteNode?
//    var cameraIsZooming = false
//    var cameraIsPanning = false
//    var camera: SKCameraNode
//    let parentScene: SKScene
//    var isDisplayingCatSelection = false
//    
//    var cats: [NewCat] = []
//    
//    init(inScene scene: SKScene) {
//
//        parentScene = scene
//        camera = SKCameraNode()
//        scene.camera = camera
//        camera.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
//        camera.addChild(HUD(inCamera: camera))
//        
//        super.init()
//    
//        wallpaper = SKPixelSpriteNode(textureName: PlistManager.sharedInstance.getValueForKey("Wallpaper") as! String, pressAction: {})
//        floor = SKPixelSpriteNode(textureName: PlistManager.sharedInstance.getValueForKey("Floor") as! String, pressAction: {})
//        
//       
//        if let catDictionary = PlistManager.sharedInstance.getValueForKey("Cats") as? NSDictionary {
//            if catDictionary.count == 0 {
//                print("***NO CATS YET***")
//                GameScene.displayCatSelection(inScene: parentScene)
//            } else {
//                print("***LOADING CATS***")
//                for cat in catDictionary as NSDictionary {
//                    if let loadedCat = NSKeyedUnarchiver.unarchiveObjectWithData(cat.value as! NSData) as? NewCat {
//                        cats.append(loadedCat)
//                        print("Loaded and initialized "+loadedCat.name)
//                        print(loadedCat.isKitten())
//                    }
//                }
//            }
//        }
//        
//        wallpaper!.setScale(46/9)
//        wallpaper!.zPosition = 0
//        wallpaper!.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
//        
//        let leftWallPaper = SKPixelSpriteNode(textureName: "wallpaper", pressAction: {})
//        leftWallPaper.setScale(46/9)
//        leftWallPaper.zPosition = -2
//        leftWallPaper.position = CGPoint(x: wallpaper!.frame.minX-leftWallPaper.frame.width/2+107, y: scene.frame.midY)
//        
//        let rightWallPaper = SKPixelSpriteNode(textureName: "wallpaper", pressAction: {})
//        rightWallPaper.setScale(46/9)
//        rightWallPaper.zPosition = -2
//        rightWallPaper.position = CGPoint(x: wallpaper!.frame.maxX+rightWallPaper.frame.width/2-107, y: scene.frame.midY)
//        
//        floor!.setScale(46/9)
//        floor!.zPosition = 1
//        floor!.position = CGPoint(x: scene.frame.midX, y: scene.frame.minY+(floor!.frame.height/2))
//        
//        let leftFloor = SKPixelSpriteNode(textureName: "floor", pressAction: {})
//        leftFloor.setScale(46/9)
//        leftFloor.zPosition = -1
//        leftFloor.position = CGPoint(x: wallpaper!.frame.minX-leftWallPaper.frame.width/2+107, y: scene.frame.minY+(floor!.frame.height/2))
//        
//        let rightFloor = SKPixelSpriteNode(textureName: "floor", pressAction: {})
//        rightFloor.setScale(46/9)
//        rightFloor.zPosition = -1
//        rightFloor.position = CGPoint(x: wallpaper!.frame.maxX+rightWallPaper.frame.width/2-107, y: scene.frame.minY+(floor!.frame.height/2))
//        
//        let bottomFloor = SKSpriteNode(color: SKColor(red: 44/255, green: 57/255, blue: 78/255, alpha: 1), size: CGSize(width: 1000, height: 1000))
//        bottomFloor.zPosition = -3
//        bottomFloor.position = CGPoint(x: scene.frame.midX, y: scene.frame.minY)
//        
//        
//        
//        scene.addChild(camera)
//        scene.addChild(wallpaper!)
//        scene.addChild(leftWallPaper)
//        scene.addChild(rightWallPaper)
//        scene.addChild(floor!)
//        scene.addChild(leftFloor)
//        scene.addChild(rightFloor)
//        scene.addChild(bottomFloor)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func addCat(name: String, alreadySaved: Bool) {
////        let testCat = NewCat(name: "Oscar", skin: "oscar", mood: "happy", birthday: NSDate(), world: self)
////        cats.append(testCat)
////        testCat.save()
//    }
//    
//    func update() {
//        // update all of the cats!
////        for cat in cats {
////            cat.update()
////        }
//    }
//}

class NewWorld: NSObject, NSCoding {
    var name: String!
    var parentScene: SKScene!
    var node: SKNode!
    var cats: [NewCat]!
    
    override var description: String { return "*** \(name) ***\ncats: \(cats)" }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.name = decoder.decodeObjectForKey("name") as! String
        self.parentScene = decoder.decodeObjectForKey("parentscene") as! SKScene
        let catsArray: [NewCat]? = decoder.decodeObjectForKey("cats") as? [NewCat]
        if catsArray != nil {
            self.cats = catsArray
        } else {
            self.cats = []
        }
    }
    
    convenience init(name: String, parentScene: SKScene) {
        self.init()
        self.name = name
        self.parentScene = parentScene
        self.cats = []
        
//        if let catDictionary = PlistManager.sharedInstance.getValueForKey("Cats") as? NSDictionary {
//            if catDictionary.count == 0 {
//                print("***NO CATS YET***")
//                GameScene.displayCatSelection(inScene: parentScene)
//            } else {
//                print("***LOADING CATS***")
//                for cat in catDictionary as NSDictionary {
//                    if let loadedCat = NSKeyedUnarchiver.unarchiveObjectWithData(cat.value as! NSData) as? NewCat {
//                        cats.append(loadedCat)
//                        print("Loaded and initialized "+loadedCat.name)
//                        print(loadedCat.isKitten())
//                    }
//                }
//            }
//        }
    }
    
    func encodeWithCoder(coder: NSCoder) {
        if let name = name { coder.encodeObject(name, forKey: "name") }
        if let parentScene = parentScene { coder.encodeObject(parentScene, forKey: "parentscene") }
        if let cats = cats { coder.encodeObject(cats, forKey: "cats") }
    }
    
    func save() {
        let worldData = NSKeyedArchiver.archivedDataWithRootObject(self)
        PlistManager.sharedInstance.saveValue(worldData, forKey: "World")
    }
    
    func addCat(name: String) {
        let testCat = NewCat(name: "Oscar", skin: "oscar", mood: "happy", birthday: NSDate(), world: self)
        cats.append(testCat)
        testCat.save()
    }
}

