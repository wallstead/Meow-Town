//
//  World.swift
//  Cat World
//
//  Created by Willis Allstead on 4/29/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class World: SKNode {
    var wallpaper: SKPixelSpriteNode?
    var floor: SKPixelSpriteNode?
    var cameraIsZooming = false
    var cameraIsPanning = false
    
    var camera: SKCameraNode
    let parentScene: SKScene
    var isDisplayingCatSelection = false
    
    var cats: [NewCat] = []
    
    init(inScene scene: SKScene) {

        parentScene = scene
        camera = SKCameraNode()
        scene.camera = camera
        camera.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        camera.addChild(HUD(inCamera: camera))
        
        super.init()
        
        
       
        wallpaper = SKPixelSpriteNode(textureName: PlistManager.sharedInstance.getValueForKey("Wallpaper") as! String, pressAction: {})
        floor = SKPixelSpriteNode(textureName: PlistManager.sharedInstance.getValueForKey("Floor") as! String, pressAction: {})
        
       
        if let catDictionary = PlistManager.sharedInstance.getValueForKey("Cats") as? NSDictionary {
            if catDictionary.count == 0 {
                print("***NO CATS YET***")
                GameScene.displayCatSelection(inScene: parentScene)
            } else {
                print("***LOADING CATS***")
                for cat in catDictionary as NSDictionary {
                    if let loadedCat = NSKeyedUnarchiver.unarchiveObjectWithData(cat.value as! NSData) as? NewCat {
                        cats.append(loadedCat)
                        print("Loaded and initialized "+loadedCat.name)
                    }
                }
            }
        }
        
//        if cats.count == 0 {
//            print("no cats currently")
//            GameScene.displayCatSelection(inScene: parentScene)
//        } else {
//            for cat in cats {
//                addCat(cat.key as! String, alreadySaved: true)
//            }
//        }
        
        wallpaper!.setScale(46/9)
        wallpaper!.zPosition = 0
        wallpaper!.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        
        let leftWallPaper = SKPixelSpriteNode(textureName: "wallpaper", pressAction: {})
        leftWallPaper.setScale(46/9)
        leftWallPaper.zPosition = -2
        leftWallPaper.position = CGPoint(x: wallpaper!.frame.minX-leftWallPaper.frame.width/2+107, y: scene.frame.midY)
        
        let rightWallPaper = SKPixelSpriteNode(textureName: "wallpaper", pressAction: {})
        rightWallPaper.setScale(46/9)
        rightWallPaper.zPosition = -2
        rightWallPaper.position = CGPoint(x: wallpaper!.frame.maxX+rightWallPaper.frame.width/2-107, y: scene.frame.midY)
        
        floor!.setScale(46/9)
        floor!.zPosition = 1
        floor!.position = CGPoint(x: scene.frame.midX, y: scene.frame.minY+(floor!.frame.height/2))
        
        let leftFloor = SKPixelSpriteNode(textureName: "floor", pressAction: {})
        leftFloor.setScale(46/9)
        leftFloor.zPosition = -1
        leftFloor.position = CGPoint(x: wallpaper!.frame.minX-leftWallPaper.frame.width/2+107, y: scene.frame.minY+(floor!.frame.height/2))
        
        let rightFloor = SKPixelSpriteNode(textureName: "floor", pressAction: {})
        rightFloor.setScale(46/9)
        rightFloor.zPosition = -1
        rightFloor.position = CGPoint(x: wallpaper!.frame.maxX+rightWallPaper.frame.width/2-107, y: scene.frame.minY+(floor!.frame.height/2))
        
        let bottomFloor = SKSpriteNode(color: SKColor(red: 44/255, green: 57/255, blue: 78/255, alpha: 1), size: CGSize(width: 1000, height: 1000))
        bottomFloor.zPosition = -3
        bottomFloor.position = CGPoint(x: scene.frame.midX, y: scene.frame.minY)
        
        
        
        scene.addChild(camera)
        scene.addChild(wallpaper!)
        scene.addChild(leftWallPaper)
        scene.addChild(rightWallPaper)
        scene.addChild(floor!)
        scene.addChild(leftFloor)
        scene.addChild(rightFloor)
        scene.addChild(bottomFloor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load() -> NSDictionary? {
        // load existing properties or set up new properties
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as String
        let path = documentsDirectory.stringByAppendingPathComponent("WorldData.plist")
        let fileManager = NSFileManager.defaultManager()
        
        // check if file exists
        if !fileManager.fileExistsAtPath(path) {
            // create an empty file if it doesn't exist
            print("No World Data")
            
            // TODO: make this display in a non-intrinsic way
            GameScene.displayCatSelection(inScene: parentScene)
            
            if let bundle = NSBundle.mainBundle().pathForResource("DefaultWorldData", ofType: "plist") {
                print("Copying New World Data From Default")
                try! fileManager.copyItemAtPath(bundle, toPath: path)
            }
        } else if fileManager.fileExistsAtPath(path) && cats.isEmpty {
            let worldData = NSMutableDictionary(contentsOfFile: path)! as NSMutableDictionary
            let catArray = worldData["Cats"] as! NSDictionary
            //if catArray.isEmpty {
               // GameScene.displayCatSelection(inScene: parentScene)
            //}
        }
        
        let data = NSDictionary(contentsOfFile: path)
        
        if data != nil {
            print(data!)
            return data!
        } else {
            print("No data was loaded")
            return nil
        }
    }
    
    func save(value: String, forKey key: String) {
        print("Old Data:")
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as String
        let path = documentsDirectory.stringByAppendingPathComponent("WorldData.plist")
        
        let worldData = NSMutableDictionary(contentsOfFile: path)! as NSMutableDictionary
        print(worldData)
        print("New Data:")
        
        
        if key == "Cats" {
            var catArray = worldData["Cats"] as! Array<String>
            let catName = value
            catArray.append(catName)
            worldData.setValue(catArray, forKey: "Cats")
        } else {
            worldData.setValue(value, forKey: key)
        }
        worldData.writeToFile(path, atomically: true)
        
        print(worldData)
    }
    
    func pause() {
        
    }
    
    func addCat(name: String, alreadySaved: Bool) {
//        let newCat = Cat(name: name.capitalizedString, skin: name, inWorld: self)
//        newCat.addActivity(newCat.flyTo(CGPoint(x: self.floor!.frame.midX, y: self.floor!.frame.midY)), priority: 1)
//        if !alreadySaved {
////            save(name, forKey: "Cats")
//        }
        
        let testCat = NewCat(name: "Oscar", skin: "oscar", mood: "happy", birthday: NSDate())
        cats.append(testCat)
        testCat.save()
        print(testCat)
    }
    
    func update() {
        // update all of the cats!
//        for cat in cats {
//            cat.update()
//        }
    }
}

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
}