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

class Cat: NSObject, NSCoding  {
    let name: String
    var skin: String
    var sprite: SKPixelCatNode
    var mood: String = "Happy"
    var birthday: NSDate
    let lifespan: TimeInterval = 5.minutes
    var world: World
    var heartBeat: Timer
    var isKitten: Bool {
        if age/lifespan < (1/15) {
            return true
        } else {
            return false
        }
    }
    var age: TimeInterval {
        return NSDate().timeIntervalSince(birthday as Date)
    }
    var hasPubed: Bool

    init(name: String, skin: String, birthday: NSDate, world: World) {
        self.name = name
        self.skin = skin
        self.sprite = SKPixelCatNode(skin)
        self.birthday = birthday
        self.world = world
        self.heartBeat = Timer()
        self.hasPubed = false
        
        super.init()
        
        birth()
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        skin = aDecoder.decodeObject(forKey: "skin") as! String
        sprite = aDecoder.decodeObject(forKey: "sprite") as! SKPixelCatNode
        mood = aDecoder.decodeObject(forKey: "mood") as! String
        birthday = aDecoder.decodeObject(forKey: "birthday") as! NSDate
        world = aDecoder.decodeObject(forKey: "world") as! World
        heartBeat = Timer()
        hasPubed = aDecoder.decodeBool(forKey: "hasPubed")
        
        super.init()
        
        displayCat()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(skin, forKey: "skin")
        aCoder.encode(sprite, forKey: "sprite")
        aCoder.encode(mood, forKey: "mood")
        aCoder.encode(birthday, forKey: "birthday")
        aCoder.encode(world, forKey: "world")
        aCoder.encode(hasPubed, forKey: "hasPubed")
    }

    func birth() {
        // Do any first-time things here (coreograph an interesting entrance?)
        print("[Cat] \(name.capitalized) has been born")

        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Oh No!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "\(name) kicked the bucket..", arguments: nil)
        content.sound = UNNotificationSound.default()

        // Deliver the notification after lifespan has passed.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: lifespan, repeats: false)
        let request = UNNotificationRequest.init(identifier: "cat_death_\(name)", content: content, trigger: trigger)

        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request)
        
        displayCat()
    }
    
    func displayCat() {
        heartBeat = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.brain()
            self.trackAge()
        }
        
        sprite.position.y = world.wallpaper.frame.minY-10
        sprite.position.x = CGFloat(Int.random(min: Int(world.floor.frame.minX-10), max: Int(world.floor.frame.maxX+10)))
        sprite.zPosition = 300
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        sprite.isUserInteractionEnabled = true
        sprite.action = {
            GameScene.current.catCam.toggleFocus(cat: self)
        }
        world.addChild(sprite)
        prance()
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
        if isKitten {
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


    func prance() {
        let randomX: Int
        let randomY: Int
        if isKitten {
            randomX = Int.random(min: Int(world.floor.frame.minX+8), max: Int(world.floor.frame.maxX-8))
            randomY = Int.random(min: Int(world.floor.frame.minY), max: Int(world.floor.frame.maxY-5))
        } else {
            randomX = Int.random(min: Int(world.floor.frame.minX+18), max: Int(world.floor.frame.maxX-18))
            randomY = Int.random(min: Int(world.floor.frame.minY), max: Int(world.floor.frame.maxY-5))
        }

        let randomPoint = CGPoint(x: randomX, y: randomY)
        flyTo(point: randomPoint)
    }

    func brain() {
        if !sprite.isBusy() {
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
        self.skin = name.lowercased()
        if GameScene.current.save(world) {
            print("[Cat] Saved after cat grew up")
        } else {
            print("[Cat] Failed to save after cat grew up")
        }
    }

    func die() {
        heartBeat.invalidate()
        // world.addGraveStone(catName: firstname!, position: sprite.position, zPos: sprite.zPosition)
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
            if GameScene.current.save(self.world) {
                print("[Cat] Saved after cat death")
            } else {
                print("[Cat] Failed to save after cat death")
            }
            if self.world.cats.isEmpty {
                GameScene.current.catCam.displayCatSelection()
            }
        })
        
        print("[Cat] \(name) has died.")
    }

    func trackAge() {
        if age >= lifespan {
            die()
        } else if !isKitten && !hasPubed && !sprite.isBusy()  {
            hasPubed = true
            pube()
        }
    }
    
    func update(currentTime: CFTimeInterval) {
        changeZPosition() //TODO: Find a more efficient way
    }

    func changeZPosition() {
        let catPosCoeff = self.sprite.position.y-world.floor.frame.minY
        let divisorCoeff = world.floor.frame.maxY-world.floor.frame.minY
        let percentageYPos = (1-(catPosCoeff/divisorCoeff))*100
        sprite.zPosition = 100 + percentageYPos
    }
}

//extension Cat: Equatable {
//    static func ==(lhs:Cat, rhs:Cat) -> Bool {
//        return lhs === rhs
//    }
//}

//
//    // MARK: Initialization
//    
//    required convenience init(coder decoder: NSCoder) {
//        heartBeat = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//            self.brain()
//            self.trackAge()
//        }
//        self.init()
//        self.firstname = decoder.decodeObject(forKey: "firstname") as! String
//        self.skin = decoder.decodeObject(forKey: "skin") as! String
//        self.sprite = decoder.decodeObject(forKey: "sprite") as! SKPixelCatNode
//        self.mood = decoder.decodeObject(forKey: "mood") as! String
//        self.birthday = decoder.decodeObject(forKey: "birthday") as! NSDate
//        self.world = decoder.decodeObject(forKey: "world") as! World
//        self.hasPubed = decoder.decodeBool(forKey: "haspubed") // TODO: Understand why this has to be decodeBool rather than just decodeObject
//        
//        displayCat()
//    }
//    
//    init(name: String, skin: String, mood: String, birthday: NSDate, world: World) {
//        self.init()
//        self.firstname = name
//        self.skin = skin+"_kitten"
//        self.mood = mood
//        self.birthday = birthday
//        self.world = world
//        self.hasPubed = false
//        
//        birth()
//    }
//    
//    override func encode(with aCoder: NSCoder) {
//        print("+++++++++++++++encoding cat+++++++++++++++")
//        if let firstname = firstname { aCoder.encode(firstname, forKey: "firstname") }
//        if let skin = skin { aCoder.encode(skin, forKey: "skin") }
//        if let sprite = sprite { aCoder.encode(sprite, forKey: "sprite") }
//        if let mood = mood { aCoder.encode(mood, forKey: "mood") }
//        if let birthday = birthday { aCoder.encode(birthday, forKey: "birthday") }
//        if let world = world { aCoder.encode(world, forKey: "world") }
//        if let hasPubed = hasPubed { aCoder.encode(hasPubed, forKey: "haspubed") }
//    }
//    
//    func birth() {
//        /* Do any first-time things here (coreograph an interesting entrance?) */
//        print("\(firstname!) has been born")
//        
//        let content = UNMutableNotificationContent()
//        content.title = NSString.localizedUserNotificationString(forKey: "Oh No!", arguments: nil)
//        content.body = NSString.localizedUserNotificationString(forKey: "\(firstname!) kicked the bucket..", arguments: nil)
//        content.sound = UNNotificationSound.default()
//        
//        // Deliver the notification after lifespan has passed.
//        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: lifespan, repeats: false)
//        let request = UNNotificationRequest.init(identifier: "cat_death_\(firstname!)", content: content, trigger: trigger)
//        
//        // Schedule the notification.
//        let center = UNUserNotificationCenter.current()
//        center.add(request)
//        
//        displayCat()
//    }
//    
//    func displayCat() {
//        /* Start cat off screen bottom left corner. */
//    
//        sprite = SKPixelCatNode(catName: skin)
//        sprite.position.y = world.wallpaper.frame.minY-10
//        sprite.position.x = CGFloat(Int.random(min: Int(world.floor.frame.minX-10), max: Int(world.floor.frame.maxX+10)))
//        sprite.zPosition = 100
//        sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
//        sprite.action = {
//            GameScene.current.catCam.toggleFocus(cat: self)
//        }
//        world.addChild(sprite)
//        prance()
//        
////        scheduler
////            .every(time: 1.0) // every one second
////            .perform( action: self=>Cat.trackAge ) // update the elapsed time label
////            .end()
////        
////        scheduler
////            .every(time: 1.0) // every tenth of a second
////            .perform( action: self=>Cat.brain ) // think
////            .end()
////        
////        scheduler.start()
//        
//        
//        
//    }
//    
//    func trackAge() {
//        if age() >= lifespan {
//            die()
//        } else if !isKitten() && !hasPubed && !isBusy()  {
//            hasPubed = true
//            pube()
//        }
//        print("test")
//    }
//    
//    func brain() {
//        print("test2")
//        if !isBusy() {
//            if world.food?.isEmpty == false {
//                var closestItem = world.food.first!
//                for item in world.food! {
//                    if item.position.distanceFromCGPoint(point: sprite.position) < closestItem.position.distanceFromCGPoint(point: sprite.position) {
//                        closestItem = item
//                    }
//                }
//                eat(item: closestItem)
//            } else {
//                let randInt = Int.random(range: 0..<100) // 0 -> 99
//                switch randInt {
//                case 0..<10:
//                    blink()
//                case 10..<60:
//                    prance()
//                case 60..<100:
//                    relax()
//                default:
//                    relax()
//                }
//            }
//        }
////        
//    }
//    
//    // MARK: Calculatable Cat Data
//    
//    func isKitten() -> Bool {
//        if age()/lifespan < (1/15) {
//            return true
//        } else {
//            return false
//        }
//    }
//    
//    func isBusy() -> Bool {
//        return sprite.hasActions()
//    }
//    
//    func age() -> TimeInterval {
//        return NSDate().timeIntervalSince(birthday as Date)
//    }
//    
//    // MARK: Cat Actions
//    
//    func die() {
////        world.addGraveStone(catName: firstname!, position: sprite.position, zPos: sprite.zPosition)
//        sprite.removeAllActions()
////        timer.pause()
////        scheduler.stop()
//        if GameScene.current.catCam.currentFocus == self {
//            GameScene.current.catCam.toggleFocus(cat: self)
//        }
//        let rise = SKAction.moveBy(x: 0, y: 50, duration: 1)
//        let dissapear = SKAction.fadeAlpha(to: 0, duration: 0.5)
//        let die = SKAction.group([rise, dissapear])
//        sprite.run(die,completion: {
//            self.sprite.removeFromParent()
//            self.world.cats.remove(at: self.world.cats.index(of: self)!)
////            GameScene.current.save()
//            self.removeFromParent()
//            if self.world.cats.isEmpty {
//                GameScene.current.catCam.displayCatSelection()
//            }
//        })
//        
//        print("\(firstname) died.")
//    }
//    
//    func flyTo(point: CGPoint, food: Item? = nil, completion: (() -> ())? = nil) {
//        var pointToFlyTo: CGPoint
//        
//        if food != nil {
//            
//            var offSet: CGFloat = 0
//            if sprite.xScale > 0 { // facing left
//                offSet = -sprite.mouth.position.x
//            } else { // facing right
//                offSet = sprite.mouth.position.x
//            }
//            
//            let facePosition = sprite.position.x + offSet
//            
//            if facePosition > (food?.position.x)! {
//                sprite.xScale = 1
//            } else {
//                sprite.xScale = -1
//            }
//        
//            var offSetFinal: CGFloat = 0
//            if sprite.xScale > 0 { // facing left
//                offSetFinal = -sprite.mouth.position.x
//            } else { // facing right
//                offSetFinal = sprite.mouth.position.x
//            }
//            
//            pointToFlyTo = CGPoint(x: point.x + offSetFinal, y: point.y - sprite.mouth.position.y)
//        } else {
//            pointToFlyTo = point
//            
//            if pointToFlyTo.x > sprite.position.x {
//                sprite.xScale = -1
//            } else {
//                sprite.xScale = 1
//            }
//        }
//        
//        let velocity: Double
//        if isKitten() {
//            velocity = 65// 65
//        } else {
//            velocity = 45//45
//        }
//        let xDist: Double = Double(pointToFlyTo.x - sprite.position.x)
//        let yDist: Double = Double(pointToFlyTo.y - sprite.position.y)
//        let distance: Double = sqrt((xDist * xDist) + (yDist * yDist))
//        let time: TimeInterval = distance/velocity //so time is dependent on distance
// 
//        sprite.liftLegs()
//        sprite.run(SKAction.moveBy(x: 0, y: 1, duration: 0.1), completion: {
//            let fly = SKAction.move(to: pointToFlyTo, duration: time)
//            fly.timingMode = .easeIn
//            self.sprite.run(fly, completion: {
//                self.sprite.run(SKAction.moveBy(x: 0, y: -1, duration: 0.1), completion: {
//                    self.sprite.stand()
//                    
//                    if completion != nil {
//                        completion!()
//                    }
//                })
//            })
//        })
//        
//        
//    }
//    
//    func prance() {
//        let randomX: Int
//        let randomY: Int
//        if isKitten() {
//            randomX = Int.random(min: Int(world.floor.frame.minX+8), max: Int(world.floor.frame.maxX-8))
//            randomY = Int.random(min: Int(world.floor.frame.minY), max: Int(world.floor.frame.maxY-5))
//        } else {
//            randomX = Int.random(min: Int(world.floor.frame.minX+18), max: Int(world.floor.frame.maxX-18))
//            randomY = Int.random(min: Int(world.floor.frame.minY), max: Int(world.floor.frame.maxY-5))
//        }
//        
//        let randomPoint = CGPoint(x: randomX, y: randomY)
//        flyTo(point: randomPoint)
//    }
//    
//    func eat(item: Item) {
//        
//        flyTo(point: item.position, food: item, completion: {
//            /* Find where the mouth is */
//            
//            let spawnCrumb = SKAction.run({
//                let randx = randomInRange(low: 1, high: Int(item.sprite.size.width-1))
//                let randy = randomInRange(low: 1, high: Int(item.sprite.size.height-1))
//                let pixPoint = CGPoint(x: randx, y: randy)
//                let randColor = UIImage(named: item.sprite.textureName)!.getPixelColor(pos: pixPoint) as SKColor
//                
//                let crumb = SKSpriteNode(color: randColor, size: CGSize(width: 1, height: 1))
//                crumb.physicsBody = SKPhysicsBody(rectangleOf: crumb.size)
//                crumb.physicsBody?.collisionBitMask = PhysicsCategory.Floor
//                crumb.zPosition = self.sprite.zPosition + 1
//                crumb.position = item.position
//                self.world.addChild(crumb)
//                
//                let angle = randomBetweenNumbers(firstNum: -0.2, secondNum: 0.2)
//                let angle2 = randomBetweenNumbers(firstNum: -0.2, secondNum: 0.2)
//                crumb.physicsBody?.applyForce(CGVector(dx: angle, dy:angle2))
//                crumb.run(SKAction.wait(forDuration: 2.5), completion: {
//                    crumb.run(SKAction.fadeAlpha(to: 0, duration: 0.05), completion: {
//                        crumb.removeFromParent()
//                    })
//                })
//            })
//            
//            let wait = SKAction.wait(forDuration: 0.15)
//            let addCrumb = SKAction.sequence([spawnCrumb,wait])
//            
//            self.sprite.run(SKAction.repeat(addCrumb, count: 5), completion: {
//                if let itemIndex = self.world.food.index(of: item) {
//                    self.world.food.remove(at: itemIndex)
//                    
//                    self.world.addPoints(item: item, location: item.position)
//                    item.removeFromParent()
//                    item.removeAllActions()
//                }
//            })
//        })
//    }
//    
//    func pube() {
//        if GameScene.current.catCam.currentFocus != self {
//            GameScene.current.catCam.toggleFocus(cat: self)
//            sprite.run(SKAction.wait(forDuration: 2), completion: {
//                if GameScene.current.catCam.currentFocus == self {
//                    GameScene.current.catCam.toggleFocus(cat: self)
//                }
//            })
//        }
//        sprite.pube()
//        self.skin = firstname.lowercased()
////        GameScene.current.save()
//    }
//    
//    func blink() {
//        sprite.closeEyes()
//        sprite.run(SKAction.wait(forDuration: 0.2), completion: {
//            self.sprite.openEyes()
//        })
//    }
//    
//    func relax() {
//        sprite.run(SKAction.wait(forDuration: TimeInterval(Int.random(range: 1..<3))))
//    }
//    
//    
//    // MARK: Update
//    
//    func update(currentTime: CFTimeInterval) {
////        timer.advance()
////        scheduler.update(dt: timer.dt)
//        changeZPosition()
//    }
//    
//    func changeZPosition() {
//        // TODO: Do z-positioning in a more efficient way
//        let catPosCoeff = self.sprite.position.y-world.floor.frame.minY
//        let divisorCoeff = world.floor.frame.maxY-world.floor.frame.minY
//        let percentageYPos = (1-(catPosCoeff/divisorCoeff))*100
//        self.sprite.zPosition = 100 + percentageYPos
//    }
//}
//
//extension Cat {
//    func pause() {
//        self.isPaused = true
////        timer.advance(paused: true)
//    }
//    
//    func unpause() {
//        self.isPaused = false
////        timer.advance(paused: false)
//    }
//}
//
//

extension SKPixelCatNode {
    func isBusy() -> Bool {
        return hasActions()
    }
}

func randomInRange(low: Int, high : Int) -> Int {
    return low + Int(arc4random_uniform(UInt32(high - low + 1)))
}

func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
}
