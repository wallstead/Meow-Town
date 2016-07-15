//
//  Item.swift
//  Cat World
//
//  Created by Willis Allstead on 7/15/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class Item: SKNode {
    var world: World!
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.world = decoder.decodeObject(forKey: "world") as! World
    }
    
    convenience init(textureName: String, world: World) {
        self.init()
        let sprite = SKPixelSpriteNode(textureName: textureName)
        sprite.zPosition = 3
        self.addChild(sprite)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        self.physicsBody?.isDynamic = true
        
        self.world = world
        world.addChild(self)
    }
    
    override func encode(with aCoder: NSCoder) {
        if let world = world { aCoder.encode(world, forKey: "world") }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        print("contact")
    }

}
