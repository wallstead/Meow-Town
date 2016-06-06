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

class NewWorld: SKNode {
    var wallpaper: SKPixelSpriteNode!
    var floor: SKPixelSpriteNode!
    var cats: [NewCat]!
    override var description: String { return "*** World ***\ncats: \(cats)" }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.wallpaper = decoder.decodeObjectForKey("wallpaper") as! SKPixelSpriteNode
        self.floor = decoder.decodeObjectForKey("floor") as! SKPixelSpriteNode
        self.cats = decoder.decodeObjectForKey("cats") as! [NewCat]
        
        layout()
        
        if self.cats.isEmpty {
            displayCatSelection()
        }
        
        
    }
    
    convenience init(name: String) {
        self.init()
        self.wallpaper = SKPixelSpriteNode(textureName: "wallpaper")
        self.floor = SKPixelSpriteNode(textureName: "floor")
        self.cats = []
        
        layout()
        
        displayCatSelection()
    }
    
    override func encodeWithCoder(coder: NSCoder) {
        if let wallpaper = wallpaper { coder.encodeObject(wallpaper, forKey: "wallpaper") }
        if let floor = floor { coder.encodeObject(floor, forKey: "floor") }
        if let cats = cats { coder.encodeObject(cats, forKey: "cats") }
    }
    
    func save() {
        let worldData = NSKeyedArchiver.archivedDataWithRootObject(self)
        PlistManager.sharedInstance.saveValue(worldData, forKey: "World")
    }
    
    func layout() {
        wallpaper.setScale(46/9)
        wallpaper.zPosition = 0
        
        floor.setScale(46/9)
        floor.zPosition = 1
        floor.position = CGPoint(x: wallpaper.frame.midX, y: wallpaper.frame.minY+(floor!.frame.height/2))
        
        self.addChild(self.wallpaper)
        self.addChild(self.floor)
    }
    
    func addCat(name: String) {
        let testCat = NewCat(name: "Oscar", skin: "oscar", mood: "happy", birthday: NSDate(), world: self)
        cats.append(testCat)
        save()
    }
    
    func displayCatSelection() {
        var isShiftingCats = false
        var catSpriteArray: [SKPixelSpriteNode] = []
        var currentCatSprite: SKPixelSpriteNode
        let circleCropNode: SKCropNode
//        let leftButton: SKPixelButtonNode
//        let rightButton: SKPixelButtonNode

        let background = SKPixelSpriteNode(textureName: "catselect_bg")
        background.setScale(46/9)
        background.zPosition = 10000
        background.alpha = 0
        
        let cats = PlistManager.sharedInstance.getValueForKey("Selectable Cats") as! NSDictionary
        for cat in cats {
            let catSkin = cat.value.valueForKey("skin") as! String
            catSpriteArray.append(SKPixelSpriteNode(textureName: catSkin))
            print(catSkin)
        }
        currentCatSprite = catSpriteArray[0]
        
        let titleBar = SKPixelSpriteNode(textureName: "catselect_titlebar")
        titleBar.setScale(46/9)
        titleBar.zPosition = 10001
        titleBar.position = CGPoint(x: wallpaper.frame.midX, y: wallpaper.frame.maxY-titleBar.frame.height/2)
        titleBar.alpha = 0
        
        let title = SKLabelNode(fontNamed: "Fipps-Regular")
        title.zPosition = 10002
        title.text = "FAT FELINE"
        title.setScale(5/10)
        title.fontSize = 80
        title.position = titleBar.position
        title.fontColor = SKColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        title.verticalAlignmentMode = .Center
        title.alpha = 0
        
        let description = SKLabelNode(fontNamed: "Silkscreen")
        description.zPosition = 10002
        description.text = "Pick A Cat"
        description.setScale(5/10)
        description.fontSize = 80
        description.position.y = title.position.y-140
        description.fontColor = SKColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        description.verticalAlignmentMode = .Center
        description.alpha = 0
        
        let circleBackground = SKPixelSpriteNode(textureName: "catselect_circle")
        circleBackground.setScale(46/9)
        circleBackground.zPosition = 10002
        circleBackground.alpha = 0
        
        circleCropNode = SKCropNode()
        circleCropNode.position = circleBackground.position
        circleCropNode.maskNode = SKPixelSpriteNode(textureName: "catselect_circle_mask")
        circleCropNode.setScale(46/9)
        circleCropNode.zPosition = 10003
        circleCropNode.alpha = 0
        
        
        for cat in catSpriteArray {
            print(cat)
            cat.position = CGPoint(x: 0+(catSpriteArray.indexOf(cat)!*55), y: 0)
            cat.alpha = 0
            circleCropNode.addChild(cat)
            cat.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        }
        
        background.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        titleBar.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        title.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        description.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        circleBackground.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        circleCropNode.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        
        self.addChild(background)
        self.addChild(titleBar)
        self.addChild(title)
        self.addChild(description)
        self.addChild(circleBackground)
        self.addChild(circleCropNode)
    }
}

