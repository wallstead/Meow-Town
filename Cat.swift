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
    let lifespan: TimeInterval = 1.hour
    var world: World!
    let timer = Timer() // the timer calculates the time step value dt for every frame
    let scheduler = Scheduler() // an event scheduler
    var hasPubed: Bool!
    
    override var description: String { return "*** \(firstname) ***\nskin: \(skin)\nmood: \(mood)\nb-day: \(birthday)" }
    
    // MARK: Initialization
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.firstname = decoder.decodeObject(forKey: "firstname") as! String
        self.skin = decoder.decodeObject(forKey: "skin") as! String
        self.sprite = decoder.decodeObject(forKey: "sprite") as! SKPixelCatNode
        self.mood = decoder.decodeObject(forKey: "mood") as! String
        self.birthday = decoder.decodeObject(forKey: "birthday") as! NSDate
        self.world = decoder.decodeObject(forKey: "world") as! World
        self.hasPubed = decoder.decodeBool(forKey: "haspubed") // TODO: Understand why this has to be decodeBool rather than just decodeObject
        
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
    
    override func encode(with aCoder: NSCoder) {
        print("+++++++++++++++encoding cat+++++++++++++++")
        if let firstname = firstname { aCoder.encode(firstname, forKey: "firstname") }
        if let skin = skin { aCoder.encode(skin, forKey: "skin") }
        if let sprite = sprite { aCoder.encode(sprite, forKey: "sprite") }
        if let mood = mood { aCoder.encode(mood, forKey: "mood") }
        if let birthday = birthday { aCoder.encode(birthday, forKey: "birthday") }
        if let world = world { aCoder.encode(world, forKey: "world") }
        if let hasPubed = hasPubed { aCoder.encode(hasPubed, forKey: "haspubed") }
    }
    
    func birth() {
        /* Do any first-time things here (coreograph an interesting entrance?) */
        print("\(firstname) has been born")
        
        displayCat()
    }
    
    func displayCat() {
        /* Start cat off screen bottom left corner. */
    
        sprite = SKPixelCatNode(catName: skin)
        sprite.position.y = world.wallpaper.frame.minY-10
        sprite.position.x = CGFloat(Int.random(min: Int(world.floor.frame.minX-10), max: Int(world.floor.frame.maxX+10)))
        sprite.zPosition = 100
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        sprite.action = {
            GameScene.current.catCam.toggleFocus(cat: self)
        }
        world.addChild(sprite)
        prance()
        
        scheduler
            .every(time: 1.0) // every one second
            .perform( action: self=>Cat.trackAge ) // update the elapsed time label
            .end()
        
        scheduler
            .every(time: 1.0) // every tenth of a second
            .perform( action: self=>Cat.brain ) // think
            .end()
        
        scheduler.start()
        
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
        if !isBusy() {
            let randInt = Int.random(range: 0..<100) // 0 -> 99
            switch randInt {
            case 0..<10:
                blink()
            case 10..<60:
                prance()
            case 60..<100:
                relax()
            default:
                print("default")
            }
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
    
    func age() -> TimeInterval {
        return NSDate().timeIntervalSince(birthday as Date)
    }
    
    // MARK: Cat Actions
    
    func die() {
        sprite.removeAllActions()
        timer.pause()
        scheduler.pause()
        if GameScene.current.catCam.currentFocus == self {
            GameScene.current.catCam.toggleFocus(cat: self)
        }
        let rise = SKAction.moveBy(x: 0, y: 50, duration: 1)
        let dissapear = SKAction.fadeAlpha(to: 0, duration: 0.5)
        let die = SKAction.group([rise, dissapear])
        sprite.run(die,completion: {
            self.sprite.removeFromParent()
            self.world.cats.remove(at: self.world.cats.index(of: self)!)
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
        let time: TimeInterval = distance/velocity //so time is dependent on distance
        if point.x > sprite.position.x {
            sprite.xScale = -1
        } else {
             sprite.xScale = 1
        }
        sprite.liftLegs()
        sprite.run(SKAction.move(to: point, duration: time), completion: {
            self.sprite.stand()
        })
    }
    
    func prance() {
        let randomX: Int
        let randomY: Int
        if isKitten() {
            randomX = Int.random(min: Int(world.floor.frame.minX+8), max: Int(world.floor.frame.maxX-8))
            randomY = Int.random(min: Int(world.floor.frame.minY), max: Int(world.floor.frame.maxY-5))
        } else {
            randomX = Int.random(min: Int(world.floor.frame.minX+18), max: Int(world.floor.frame.maxX-18))
            randomY = Int.random(min: Int(world.floor.frame.minY), max: Int(world.floor.frame.maxY-5))
        }
        
        let randomPoint = CGPoint(x: randomX, y: randomY)
        flyTo(point: randomPoint)
    }
    
    func pube() {
        
        if GameScene.current.catCam.currentFocus != self {
            GameScene.current.catCam.toggleFocus(cat: self)
            sprite.run(SKAction.wait(forDuration: 2), completion: {
                if GameScene.current.catCam.currentFocus == self {
                    GameScene.current.catCam.toggleFocus(cat: self)
                }
            })
        }
        sprite.pube()
        self.skin = firstname.lowercased()
        world.save()
    }
    
    func blink() {
        sprite.closeEyes()
        sprite.run(SKAction.wait(forDuration: 0.2), completion: {
            self.sprite.openEyes()
        })
    }
    
    func relax() {
        sprite.run(SKAction.wait(forDuration: TimeInterval(Int.random(range: 1..<3))))
    }
    
    // MARK: Update
    
    func update(currentTime: CFTimeInterval) {
        timer.advance()
        scheduler.update(dt: timer.dt)
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
        self.isPaused = true
        timer.advance(paused: true)
    }
    
    func unpause() {
        self.isPaused = false
        timer.advance(paused: false)
    }
}

