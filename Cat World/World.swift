//
//  World.swift
//  Cat World
//
//  Created by Willis Allstead on 4/29/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

struct PhysicsCategory {
    static let None       : UInt32 = 0
    static let All        : UInt32 = UInt32.max
    static let Floor      : UInt32 = 0b1       // 1
    static let Item       : UInt32 = 0b10      // 2
}

class World: SKNode, SKPhysicsContactDelegate {
    var wallpaper: SKPixelSpriteNode!
    var floor: SKPixelSpriteNode!
    var floorCollisionBox: SKSpriteNode?
    var cats: [Cat]!
    var food: [Item]!
    var score: Int!
    
    override var description: String { return "*** World ***\ncats: \(cats)" }
    
    // MARK: Initialization
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.wallpaper = decoder.decodeObject(forKey: "wallpaper") as! SKPixelSpriteNode
        self.floor = decoder.decodeObject(forKey: "floor") as! SKPixelSpriteNode
        self.cats = decoder.decodeObject(forKey: "cats") as? [Cat]
        self.score = decoder.decodeInteger(forKey: "score")
        self.food = []
        
        layout()
        
        if self.cats.isEmpty {
            GameScene.current.catCam.displayCatSelection()
        }
    }
    
    convenience init(name: String) {
        self.init()
        self.wallpaper = SKPixelSpriteNode(textureName: "wallpaper")
        self.floor = SKPixelSpriteNode(textureName: "floor")
        self.cats = []
        self.food = []
        self.score = 0
        
        layout()
        
        
        GameScene.current.catCam.displayCatSelection()
    }
    
    override func encode(with aCoder: NSCoder) {
        print("+++++++++++++++ encoding world +++++++++++++++")
        if let wallpaper = wallpaper { aCoder.encode(wallpaper, forKey: "wallpaper") }
        if let floor = floor { aCoder.encode(floor, forKey: "floor") }
        if let cats = cats {
            aCoder.encode(cats, forKey: "cats")
            print("saving this to cats: \(cats)")
        }
        if let score = score { aCoder.encode(score, forKey: "score") }
    }
    
    // MARK: Saving
    
    func save() {
        let worldData = NSKeyedArchiver.archivedData(withRootObject: self)
        PlistManager.sharedInstance.saveValue(value: worldData, forKey: "World")
    }
    
    // MARK: Layout
    
    func layout() {
        GameScene.current.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        GameScene.current.physicsWorld.contactDelegate = self
        GameScene.current.physicsWorld.speed = 1
        
        GameScene.current.catCam.updateScore(score: score)
        
        self.setScale(GameScene.current.frame.width/wallpaper.frame.width)
        wallpaper.zPosition = 0
        floor.zPosition = 2
        floor.position = CGPoint(x: wallpaper.frame.midX, y: wallpaper.frame.minY+(floor!.frame.height/2))
        for i in -1...1 {
            if i != 0 {
                let wallpaperCopy = SKPixelSpriteNode(textureName: wallpaper.textureName)
                wallpaperCopy.position.x = 60*CGFloat(i)
                wallpaperCopy.zPosition = 0
                self.addChild(wallpaperCopy)
            }
            for j in 0...2 {
                let floorCopy = SKPixelSpriteNode(textureName: floor.textureName)
                floorCopy.position.y = floor.position.y-(CGFloat(j)*30)
                floorCopy.position.x = 60*CGFloat(i)
                floorCopy.zPosition = 2-CGFloat(j)
                self.addChild(floorCopy)
            }
        }
        
        floorCollisionBox = SKSpriteNode(color: SKColor.clear(), size: CGSize(width: floor.currentWidth*3, height: 5))
        floorCollisionBox!.physicsBody = SKPhysicsBody(rectangleOf: floorCollisionBox!.size)
        floorCollisionBox!.physicsBody?.affectedByGravity = false
        floorCollisionBox!.physicsBody?.isDynamic = false
        floorCollisionBox!.physicsBody?.categoryBitMask = PhysicsCategory.Floor // 3
//        floorCollisionBox.physicsBody?.contactTestBitMask = PhysicsCategory.Item // 4
        floorCollisionBox!.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        floorCollisionBox!.position.y = floor.position.y-10
        
        floorCollisionBox!.zPosition = 3
        
        self.addChild(self.wallpaper)
        self.addChild(self.floor)
        self.addChild(floorCollisionBox!)
        
//        spawn(itemName: "burger")
    }
    
    
    
    // MARK: Cat Stuff
    
    func addCat(name: String) {
        let testCat = Cat(name: name.capitalized, skin: name, mood: "happy", birthday: NSDate(), world: self)
        cats.append(testCat)
        save()
    }
    
    func spawn(itemName: String) {
        let item = Item(textureName: itemName, parentWorld: self)
        item.zPosition = 172 // down floor -> up in z
        item.position.y = wallpaper.frame.maxY
        
        item.physicsBody?.categoryBitMask = PhysicsCategory.Item
        item.physicsBody?.contactTestBitMask = PhysicsCategory.Floor
        item.physicsBody?.collisionBitMask = PhysicsCategory.All
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == PhysicsCategory.Floor && secondBody.categoryBitMask == PhysicsCategory.Item {
//            print("yo")
            
        } else {
//            print("no")
        }
    }
    
    // MARK: Update
    
    func update(currentTime: CFTimeInterval) {
        for cat in cats {
            cat.update(currentTime: currentTime)
        }
        if floorCollisionBox != nil {
            for itemBody in floorCollisionBox!.physicsBody!.allContactedBodies() {
                if itemBody.isResting && itemBody.categoryBitMask == PhysicsCategory.Item {
                    itemBody.isDynamic = false
                    food.append(itemBody.node as! Item)
                }
            }
        }
    }
    
    
}

