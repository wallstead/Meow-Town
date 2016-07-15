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
    var wallpaper: SKPixelSpriteNode!
    var floor: SKPixelSpriteNode!
    var cats: [Cat]!
    var score: Int!
    
    override var description: String { return "*** World ***\ncats: \(cats)" }
    
    // MARK: Initialization
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.wallpaper = decoder.decodeObject(forKey: "wallpaper") as! SKPixelSpriteNode
        self.floor = decoder.decodeObject(forKey: "floor") as! SKPixelSpriteNode
        self.cats = decoder.decodeObject(forKey: "cats") as? [Cat]
        self.score = decoder.decodeObject(forKey: "score") as! Int
        
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
        
        self.addChild(self.wallpaper)
        self.addChild(self.floor)
    }
    
    
    
    // MARK: Cat Stuff
    
    func addCat(name: String) {
        let testCat = Cat(name: name.capitalized, skin: name, mood: "happy", birthday: NSDate(), world: self)
        cats.append(testCat)
        save()
    }
    
    // MARK: Update
    
    func update(currentTime: CFTimeInterval) {
        for cat in cats {
            cat.update(currentTime: currentTime)
        }
    }
}

