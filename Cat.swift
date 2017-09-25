//
//  Cat.swift
//  Meow Town
//
//  Created by Willis Allstead on 4/7/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit
import UserNotifications

class Cat: SKNode {
    var firstname: String!
    var skin: String!
    var sprite: SKPixelCatNode!
    var mood: String!
    var birthday: NSDate!
    let lifespan: TimeInterval = 30.minutes
    var world: World!
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
        print("tesfasdkjfjkaskjlfdskljafslkd")
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
        print("\(firstname!) has been born")
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Oh No!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "\(firstname!) kicked the bucket..", arguments: nil)
        content.sound = UNNotificationSound.default()
        
        // Deliver the notification after lifespan has passed.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: lifespan, repeats: false)
        let request = UNNotificationRequest.init(identifier: "cat_death_\(firstname!)", content: content, trigger: trigger)
        
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request)
        
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
        
        let wait = SKAction.wait(forDuration: 1)
        let dothing = SKAction.run {
            self.brain()
            self.trackAge()
        }
        sprite.run(SKAction.repeatForever(SKAction.sequence([dothing, wait])))
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
        if world.food?.isEmpty == false {
            var closestItem = world.food.first!
            for item in world.food! {
                if item.position.distanceFromCGPoint(point: sprite.position) < closestItem.position.distanceFromCGPoint(point: sprite.position) {
                    closestItem = item
                }
            }
            eat(item: closestItem)
        } else {
            let randInt = Int.random(range: 0..<100) // 0 -> 99
            switch randInt {
            case 0..<10:
                blink()
            case 10..<60:
                prance()
            case 60..<100:
                relax()
            default:
                relax()
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
//        world.addGraveStone(catName: firstname!, position: sprite.position, zPos: sprite.zPosition)
        sprite.removeAllActions()
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
    
    func flyTo(point: CGPoint, food: Item? = nil, completion: (() -> ())? = nil) {
        var pointToFlyTo: CGPoint
        
        if food != nil {
            
            var offSet: CGFloat = 0
            if sprite.xScale > 0 { // facing left
                offSet = -sprite.mouth.position.x
            } else { // facing right
                offSet = sprite.mouth.position.x
            }
            
            let facePosition = sprite.position.x + offSet
            
            if facePosition > (food?.position.x)! {
                sprite.xScale = 1
            } else {
                sprite.xScale = -1
            }
        
            var offSetFinal: CGFloat = 0
            if sprite.xScale > 0 { // facing left
                offSetFinal = -sprite.mouth.position.x
            } else { // facing right
                offSetFinal = sprite.mouth.position.x
            }
            
            pointToFlyTo = CGPoint(x: point.x + offSetFinal, y: point.y - sprite.mouth.position.y)
        } else {
            pointToFlyTo = point
            
            if pointToFlyTo.x > sprite.position.x {
                sprite.xScale = -1
            } else {
                sprite.xScale = 1
            }
        }
        
        let velocity: Double
        if isKitten() {
            velocity = 65// 65
        } else {
            velocity = 45//45
        }
        let xDist: Double = Double(pointToFlyTo.x - sprite.position.x)
        let yDist: Double = Double(pointToFlyTo.y - sprite.position.y)
        let distance: Double = sqrt((xDist * xDist) + (yDist * yDist))
        let time: TimeInterval = distance/velocity //so time is dependent on distance
 
        sprite.liftLegs()
        sprite.run(SKAction.moveBy(x: 0, y: 1, duration: 0.1), completion: {
            let fly = SKAction.move(to: pointToFlyTo, duration: time)
            fly.timingMode = .easeIn
            self.sprite.run(fly, completion: {
                self.sprite.run(SKAction.moveBy(x: 0, y: -1, duration: 0.1), completion: {
                    self.sprite.stand()
                    
                    if completion != nil {
                        completion!()
                    }
                })
            })
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
    
    func eat(item: Item) {
        
        flyTo(point: item.position, food: item, completion: {
            /* Find where the mouth is */
            
            let spawnCrumb = SKAction.run({
                let randx = randomInRange(low: 1, high: Int(item.sprite.size.width-1))
                let randy = randomInRange(low: 1, high: Int(item.sprite.size.height-1))
                let pixPoint = CGPoint(x: randx, y: randy)
                let randColor = UIImage(named: item.sprite.textureName)!.getPixelColor(pos: pixPoint) as SKColor
                
                let crumb = SKSpriteNode(color: randColor, size: CGSize(width: 1, height: 1))
                crumb.physicsBody = SKPhysicsBody(rectangleOf: crumb.size)
                crumb.physicsBody?.collisionBitMask = PhysicsCategory.Floor
                crumb.zPosition = self.sprite.zPosition + 1
                crumb.position = item.position
                self.world.addChild(crumb)
                
                let angle = randomBetweenNumbers(firstNum: -0.2, secondNum: 0.2)
                let angle2 = randomBetweenNumbers(firstNum: -0.2, secondNum: 0.2)
                crumb.physicsBody?.applyForce(CGVector(dx: angle, dy:angle2))
                crumb.run(SKAction.wait(forDuration: 2.5), completion: {
                    crumb.run(SKAction.fadeAlpha(to: 0, duration: 0.05), completion: {
                        crumb.removeFromParent()
                    })
                })
            })
            
            let wait = SKAction.wait(forDuration: 0.15)
            let addCrumb = SKAction.sequence([spawnCrumb,wait])
            
            self.sprite.run(SKAction.repeat(addCrumb, count: 5), completion: {
                if let itemIndex = self.world.food.index(of: item) {
                    self.world.food.remove(at: itemIndex)
                    
                    self.world.addPoints(item: item, location: item.position)
                    item.removeFromParent()
                    item.removeAllActions()
                }
            })
        })
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
//        timer.advance(paused: true)
    }
    
    func unpause() {
        self.isPaused = false
//        timer.advance(paused: false)
    }
}



func randomInRange(low: Int, high : Int) -> Int {
    return low + Int(arc4random_uniform(UInt32(high - low + 1)))
}

func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
}
