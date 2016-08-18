//
//  World.swift
//  Meow Town
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
        self.score = decoder.decodeInteger(forKey: "calories")
        self.food = []
        
        layout()
        
        if self.cats.isEmpty {
            GameScene.current.catCam.displayCatSelection()
            
        }
    }
    
    convenience init(name: String) {
        self.init()
        self.wallpaper = SKPixelSpriteNode(pixelImageNamed: "wallpaper_greenforest")
        self.floor = SKPixelSpriteNode(pixelImageNamed: "floor")
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
        if let score = score { aCoder.encode(score, forKey: "calories") }
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
//        GameScene.current.physicsWorld.speed = 1
        GameScene.current.catCam.updateScore(score: score!)
        self.setScale(GameScene.current.frame.width/floor.frame.width)
        
        floor.zPosition = 2
        floor.position.y = -floor!.frame.height*1.3
        for i in -1...1 {
            for j in 0...2 {
                let floorCopy = SKPixelSpriteNode(pixelImageNamed: floor.textureName)
                floorCopy.position.y = floor.position.y-(CGFloat(j)*30)
                floorCopy.position.x = 60*CGFloat(i)
                floorCopy.zPosition = 2-CGFloat(j)
                self.addChild(floorCopy)
            }
        }
        
        wallpaper.zPosition = 3
        wallpaper.position.x = floor.frame.minX + wallpaper.width/2 - wallpaper.width*4
        wallpaper.position.y = floor.frame.maxY + wallpaper.height/2
        for i in 1...8 {
            for j in 0...3 {
                let wallpaperCopy = SKPixelSpriteNode(pixelImageNamed: wallpaper.textureName)
                wallpaperCopy.position.y = wallpaper.position.y+wallpaper.height*CGFloat(j)
                wallpaperCopy.position.x = wallpaper.position.x+wallpaper.width*CGFloat(i)
                wallpaperCopy.zPosition = 3
                self.addChild(wallpaperCopy)
            }
        }
        
        floorCollisionBox = SKSpriteNode(color: SKColor.clear(), size: CGSize(width: floor.currentWidth*3, height: 15))
        floorCollisionBox!.position.y = floor.position.y-10
        floorCollisionBox!.zPosition = 3
        
        floorCollisionBox!.physicsBody = SKPhysicsBody(rectangleOf: floorCollisionBox!.size)
        floorCollisionBox!.physicsBody!.affectedByGravity = false
        floorCollisionBox!.physicsBody!.isDynamic = false
        floorCollisionBox!.physicsBody!.categoryBitMask = PhysicsCategory.Floor // 3
        floorCollisionBox!.physicsBody!.contactTestBitMask = PhysicsCategory.Item
        floorCollisionBox!.physicsBody!.collisionBitMask = PhysicsCategory.None // 5
        
        self.addChild(self.wallpaper)
        self.addChild(self.floor)
        self.addChild(floorCollisionBox!)
        
        spawn(itemName: "burger")
        spawn(itemName: "fries")
        spawn(itemName: "fries")
    }
    
    // MARK: Cat Stuff
    
    func addCat(name: String) {
        let testCat = Cat(name: name.capitalized, skin: name, mood: "happy", birthday: NSDate(), world: self)
        cats.append(testCat)
        save()
    }
    
    func addGraveStone(catName: String, position: CGPoint, zPos: CGFloat) {
//        let graveStone = SKPixelSpriteNode(pixelImageNamed: "gravestone")
//        graveStone.position = position
//        graveStone.anchorPoint = CGPoint(x: 0.5, y: 0)
//        graveStone.zPosition = zPos
//        self.addChild(graveStone)
//        
//        let rip = SKLabelNode(fontNamed: "Silkscreen-bold")
//        rip.zPosition = graveStone.zPosition+1
//        rip.text = "RIP"
//        rip.setScale(1/10)
//        rip.fontSize = 80
//        rip.fontColor = SKColor(colorLiteralRed: 52/255, green: 52/255, blue: 52/255, alpha: 1)
//        rip.verticalAlignmentMode = .center
//        rip.position.y = 20
//        graveStone.addChild(rip)
    }
    
    func addPoints(item: Item, location: CGPoint? = nil) {
        let storeDict = PlistManager.sharedInstance.getValueForKey(key: "Store") as! NSDictionary
        let categoriesDict = storeDict.value(forKey: "Categories") as! NSDictionary
        let foodsDict = categoriesDict.value(forKey: "Foods") as! NSDictionary
        let itemDict = foodsDict.value(forKey: item.sprite!.textureName) as! NSDictionary
        let infoDict = itemDict.value(forKey: "info") as! NSDictionary
        let points = infoDict.value(forKey: "calories") as! Int
        
        if location != nil {
            let pointLabel = SKLabelNode(fontNamed: "Silkscreen")
            pointLabel.zPosition = item.zPosition+1
            pointLabel.text = "+\(points)"
            pointLabel.setScale(1/10)
            pointLabel.fontSize = 80
            pointLabel.fontColor = SKColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            pointLabel.verticalAlignmentMode = .center
            pointLabel.position = location!
            self.addChild(pointLabel)
            
            pointLabel.run(SKAction.group([SKAction.moveBy(x: 0, y: 30, duration: 1.5), SKAction.fadeOut(withDuration: 1.2)]), completion: {
                pointLabel.removeFromParent()
            })
        }
        
        score = score + points
        GameScene.current.catCam.updateScore(score: score)
        print("score: \(score!)")
    }

    func spawn(itemName: String) {
        let item = Item(pixelImageNamed: itemName, parentWorld: self)
        item.zPosition = 163
        
        
        
        item.position.y = wallpaper.frame.maxY
        item.physicsBody!.categoryBitMask = PhysicsCategory.Item
        item.physicsBody!.contactTestBitMask = PhysicsCategory.Floor | PhysicsCategory.Item
        item.physicsBody!.collisionBitMask = PhysicsCategory.Floor | PhysicsCategory.Item
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

