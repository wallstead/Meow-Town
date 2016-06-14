//
//  Cat.swift
//  Cat World
//
//  Created by Willis Allstead on 4/7/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class Cat: SKNode {
    var firstname: String!
    var skin: String!
    var sprite: SKPixelCatNode!
    var mood: String!
    var birthday: NSDate!
    let lifespan: NSTimeInterval = 30.seconds
    var world: World!
    let timer = Timer() // the timer calculates the time step value dt for every frame
    let scheduler = Scheduler() // an event scheduler
    var hasPubed: Bool!
    
    override var description: String { return "*** \(firstname) ***\nskin: \(skin)\nmood: \(mood)\nb-day: \(birthday)" }
    
    // MARK: Initialization
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.firstname = decoder.decodeObjectForKey("firstname") as! String
        self.skin = decoder.decodeObjectForKey("skin") as! String
        self.sprite = decoder.decodeObjectForKey("sprite") as! SKPixelCatNode
        self.mood = decoder.decodeObjectForKey("mood") as! String
        self.birthday = decoder.decodeObjectForKey("birthday") as! NSDate
        self.world = decoder.decodeObjectForKey("world") as! World
        self.hasPubed = decoder.decodeObjectForKey("hasPubed") as! Bool
        print(self.skin)
        print(self.hasPubed)
        displayCat()
    }
    
    convenience init(name: String, skin: String, mood: String, birthday: NSDate, world: World) {
        self.init()
        self.firstname = name
        self.skin = skin+"_kitten"
        self.mood = mood
        self.birthday = birthday
        self.world = world
        self.hasPubed = false
        
        birth()
    }
    
    override func encodeWithCoder(coder: NSCoder) {
        if let firstname = firstname { coder.encodeObject(firstname, forKey: "firstname") }
        if let skin = skin { coder.encodeObject(skin, forKey: "skin") }
        if let sprite = sprite { coder.encodeObject(sprite, forKey: "sprite") }
        if let mood = mood { coder.encodeObject(mood, forKey: "mood") }
        if let birthday = birthday { coder.encodeObject(birthday, forKey: "birthday") }
        if let world = world { coder.encodeObject(world, forKey: "world") }
        if let hasPubed = hasPubed { coder.encodeObject(hasPubed, forKey: "hasPubed") }
    }
    
    func birth() {
        /* Do any first-time things here (coreograph an interesting entrance?) */
        print("\(name) has been born")
        displayCat()
    }
    
    func displayCat() {
        /* Start cat off screen bottom left corner. */
        
        sprite = SKPixelCatNode(catName: self.skin)
        sprite.position.y = world.wallpaper.frame.minY
        sprite.position.x = world.wallpaper.frame.minX-10
        sprite.zPosition = 100
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        sprite.action = {
            GameScene.current.catCam.toggleFocus(self)
        }
        world.addChild(sprite)
        flyTo(self.world.floor.frame.mid())
        
        scheduler
            .every(1.0) // every one second
            .perform( self=>Cat.trackAge ) // update the elapsed time label
            .end()
        
        scheduler
            .every(2) // every tenth of a second
            .perform( self=>Cat.brain ) // think
            .end()
        
        scheduler.start()
        
        print("\(name) has been displayed")
    }
    
    func trackAge() {
        if age() >= lifespan {
            die()
        } else if !isKitten() && !hasPubed && !isBusy()  {
            hasPubed = true
            pube()
        }
    }
    
    func brain() {
        // if needs to eat, do that
        // if needs to blink, do that
        // if needs to fly around, do that
        if !isBusy() {
            prance()
        }
    }
    
    // MARK: Calculatable Cat Data
    
    func isKitten() -> Bool {
        if age()/lifespan < (1/15) {
            return true
        } else {
            return false
        }
    }
    
    func isBusy() -> Bool {
        return sprite.hasActions()
    }
    
    func age() -> NSTimeInterval {
        return NSDate().timeIntervalSinceDate(birthday)
    }
    
    // MARK: Cat Actions
    
    func die() {
        timer.pause()
        scheduler.pause()
        if GameScene.current.catCam.currentFocus == self {
            GameScene.current.catCam.toggleFocus(self)
        }
        let flip = SKAction.rotateByAngle(3.14, duration: 1)
        let dissapear = SKAction.fadeAlphaTo(0, duration: 0.5)
        let die = SKAction.sequence([flip, dissapear])
        sprite.runAction(die,completion: {
            self.sprite.removeFromParent()
            self.world.cats.removeAtIndex(self.world.cats.indexOf(self)!)
            self.world.save()
            self.removeFromParent()
            if self.world.cats.isEmpty {
                GameScene.current.catCam.displayCatSelection()
            }
        })
        
        print("\(firstname) died.")
    }
    
    func flyTo(point: CGPoint) {
        let velocity: Double
        if isKitten() {
            velocity = 65
        } else {
            velocity = 45
        }
        let xDist: Double = Double(point.x - sprite.position.x)
        let yDist: Double = Double(point.y - sprite.position.y)
        let distance: Double = sqrt((xDist * xDist) + (yDist * yDist))
        let time: NSTimeInterval = distance/velocity //so time is dependent on distance
        if point.x > sprite.position.x {
            sprite.xScale = -1
        } else {
             sprite.xScale = 1
        }
        sprite.liftLegs()
        sprite.runAction(SKAction.moveTo(point, duration: time), completion: {
            self.sprite.stand()
        })
        
    }
    
    func prance() {
        let randomX: Int
        let randomY: Int
        if isKitten() {
            randomX = Int.random(Int(CGRectGetMinX(world.floor.frame)+8)...Int(CGRectGetMaxX(world.floor.frame)-8))
            randomY = Int.random(Int(CGRectGetMinY(world.floor.frame))...Int(CGRectGetMaxY(world.floor.frame)-5))
        } else {
            randomX = Int.random(Int(CGRectGetMinX(world.floor.frame)+18)...Int(CGRectGetMaxX(world.floor.frame)-18))
            randomY = Int.random(Int(CGRectGetMinY(world.floor.frame))...Int(CGRectGetMaxY(world.floor.frame)-5))
        }
        
        let randomPoint = CGPoint(x: randomX, y: randomY)
        flyTo(randomPoint)
    }
    
    func pube() {
        
        if GameScene.current.catCam.currentFocus != self {
            GameScene.current.catCam.toggleFocus(self)
            sprite.runAction(SKAction.waitForDuration(2), completion: {
                if GameScene.current.catCam.currentFocus == self {
                    GameScene.current.catCam.toggleFocus(self)
                }
            })
        }
        sprite.pube()
        self.skin = firstname.lowercaseString
        world.save()
    }
    
    // MARK: Update
    
    func update(currentTime: CFTimeInterval) {
        timer.advance()
        scheduler.update(timer.dt)
        changeZPosition()
    }
    
    func changeZPosition() {
        // TODO: Do z-positioning in a more efficient way
        let catPosCoeff = self.sprite.position.y-world.floor.frame.minY
        let divisorCoeff = world.floor.frame.maxY-world.floor.frame.minY
        let percentageYPos = (1-(catPosCoeff/divisorCoeff))*100
        self.sprite.zPosition = 100 + percentageYPos
    }
}

extension Cat {
    func pause() {
        self.paused = true
        timer.advance(true)
    }
    
    func unpause() {
        self.paused = false
        timer.advance(false)
    }
}

