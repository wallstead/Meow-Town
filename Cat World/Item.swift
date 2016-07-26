//
//  Item.swift
//  Cat World
//
//  Created by Willis Allstead on 7/15/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class Item: SKNode, SKPhysicsContactDelegate {
    var world: World!
    var sprite: SKPixelSpriteNode!
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.world = decoder.decodeObject(forKey: "world") as! World
        self.sprite = decoder.decodeObject(forKey: "sprite") as! SKPixelSpriteNode
    }
    
    convenience init(textureName: String, parentWorld: World) {
        self.init()
        
        sprite = SKPixelSpriteNode(textureName: textureName)
        sprite.zPosition = 0
        self.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        self.physicsBody?.friction = 0.2
        self.physicsBody?.restitution = 0.2
        self.physicsBody?.mass = 0.1134
        self.physicsBody?.isDynamic = true
        self.addChild(sprite)
        
        self.world = parentWorld
        world.addChild(self)
    }
    
    override func encode(with aCoder: NSCoder) {
        if let world = world { aCoder.encode(world, forKey: "world") }
        if let sprite = sprite { aCoder.encode(sprite, forKey: "sprite") }
    }
    
  
}
