//
//  Cat.swift
//  Cat World
//
//  Created by Willis Allstead on 4/7/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

//public class Cat {
//    var being: Being
//    
//    let world: World
//    let sprite: SKPixelSpriteNode
//    var todoQueue: PriorityQueue<Activity>
//    
//    var isBusy = false
//    var isAlive = true
//    var isFocusing = false
//    var isFocusedOn = false
//    var isKitten = true
//    
//    init(name: String, skin: String, inWorld: World) {
//        self.world = inWorld;
//        
//        let birthday = NSDate()
//        let lifespan = NSTimeInterval(0.04166666667) // 0.04166666667 = 1 hour in real time
//        
//        self.being = Being(name: name, skin: skin, birthday: birthday, lifespan: lifespan)
//        
//        self.sprite = SKPixelSpriteNode(textureName: skin+"_kitten", pressAction: {})
//        self.sprite.zPosition = 100
//        self.sprite.position = CGPoint(x: self.world.frame.midX, y: self.world.frame.midY)
//        self.sprite.userInteractionEnabled = true
//        self.sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
//        self.sprite.setScale(46/9)
//        
//        self.world.addChild(self.sprite)
//        
//        self.todoQueue = PriorityQueue(ascending: true, startingValues: [])
////        self.world.cats.append(self)
//    
//        sprite.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock({
//            self.doThings()
//            self.trackAge()
//        }), SKAction.waitForDuration(1)])))
//
//        doThings()
//        trackAge()
//        
//        sprite.pressAction = {
//            self.printInfo()
//            self.toggleFocus()
//        }
//    }
//    
//    func trackAge() {
//        if isAlive {
//            let secondsAged = NSDate().timeIntervalSinceDate(being.birthday)
//            being.age = secondsAged/86400
//            
//            if (being.lifespan-being.age <= 0 && todoQueue.isEmpty && !isBusy) {
//                die()
//            }
//            
//            // cats are kittens for 1 year out of their lives (about 1/15 of their lifetime)
//            if (isKitten && being.age >= being.lifespan/15 && todoQueue.isEmpty && !isBusy) {
//                pube()
//            }
//        }
//    }
//    
//    func doThings() {
//        if isAlive {
//            if !todoQueue.isEmpty && !isBusy {
//                isBusy = true
//                if let action = todoQueue.peek()?.action {
//                    sprite.runAction(action, completion: {
//                        self.todoQueue.pop()
//                        self.isBusy = false
//                    })
//                } else { print("\(being.name) has things to do but cannot do them.") }
//            } else if todoQueue.isEmpty && !isBusy {
//                let randomNumber = randomPercent()
//                switch(randomNumber) {
//                    
//                case 0..<50:
//                    prance()
//                default:
//                    print("")
//                }
//
//            }
//        } else { print("dead men do no things.") }
//    }
//    
//    func addActivity(action: SKAction, priority: Int) {
//        todoQueue.push(Activity(action: action, priority: priority))
//    }
//    
//    func printInfo() {
//        let simpleBirthDay: String = NSDateFormatter.localizedStringFromDate(being.birthday, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
//        let simpleDeathDay: String = NSDateFormatter.localizedStringFromDate(being.deathday, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
//        let lifeLeft = being.lifespan-being.age
//        
//        let numberOfPlaces = 5.0
//        let multiplier = pow(10.0, numberOfPlaces)
//        
//        print("-------- Cat Info -------")
//        print("name: \(being.name)")
//        print("skin: \(being.skin)")
//        print("mood: \(being.mood)")
//        print("age: \(round(being.age * multiplier) / multiplier) years")
//        print("life span: \(round(being.lifespan * multiplier) / multiplier) years")
//        if isAlive {
//            print("life remaining: \(round(lifeLeft * multiplier) / multiplier) years")
//        } else {
//            print("life remaining: 0")
//
//        }
//        print("birthday: \(simpleBirthDay)")
//        print("deathday: \(simpleDeathDay)")
//        print("todo count: \(todoQueue.count)")
//    }
//    
//    
//    func pube() {
//        isBusy = true
//        /* cover non-ui parts with black */
//        let tempBG = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: world.wallpaper!.size.width*2, height: world.wallpaper!.size.height*2))
//        tempBG.position = world.wallpaper!.position
//        tempBG.zPosition = 800
//        tempBG.alpha = 0
//        sprite.zPosition = 801
//        
//        world.addChild(tempBG)
//        
//        let cropped1 = SKSpriteNode(color: SKColor.whiteColor(), size: self.world.wallpaper!.size)
//        cropped1.alpha = 0
//        let cropped2 = SKSpriteNode(color: SKColor.whiteColor(), size: self.world.wallpaper!.size)
//        cropped2.alpha = 0
//        
//        let kittenCropNode = SKCropNode()
//        let kittenmask = SKPixelSpriteNode(textureName: being.skin+"_kitten", pressAction: {})
//        kittenmask.anchorPoint = CGPoint(x: 0.5, y: 0)
//        kittenCropNode.maskNode = kittenmask
//        kittenCropNode.xScale = self.sprite.xScale
//        kittenCropNode.yScale = self.sprite.yScale
//        kittenCropNode.zPosition = 802
//        kittenCropNode.addChild(cropped1)
//        kittenCropNode.position = self.sprite.position
//        kittenCropNode.alpha = 1
//        
//        let grownCatCropNode = SKCropNode()
//        let grownCatmask = SKPixelSpriteNode(textureName: being.skin, pressAction: {})
//        grownCatmask.anchorPoint = CGPoint(x: 0.5, y: 0)
//        grownCatCropNode.maskNode = grownCatmask
//        grownCatCropNode.xScale = 0
//        grownCatCropNode.yScale = 0
//        grownCatCropNode.zPosition = 802
//        grownCatCropNode.addChild(cropped2)
//        grownCatCropNode.position = self.sprite.position
//        grownCatCropNode.alpha = 1
//        
//        
//        self.world.addChild(kittenCropNode)
//        self.world.addChild(grownCatCropNode)
//        
//        // focus if not already focused
//        let previouslyFocused = isFocusedOn
//        if !previouslyFocused {
//            isFocusedOn = true
//        }
//
//        // TODO: do all of this better
//        
//        tempBG.runAction(SKAction.fadeInWithDuration(0.57), completion: {
//            /* Add a white node the size of the floor which will be used as a crop of the others */
//            cropped1.runAction(SKAction.fadeInWithDuration(0.57), completion: {
//                self.sprite.zPosition = 100;
//                func recurse(timeSpent: Int) {
//                    if timeSpent < 13 {
//                        let duration: NSTimeInterval = (14 - Double(timeSpent))/30
//                        let shrink = SKAction.scaleTo(0, duration: duration)
//                        shrink.timingMode = .EaseIn
//                        let growX = SKAction.scaleXTo(self.sprite.xScale, duration: duration)
//                        let growY = SKAction.scaleYTo(self.sprite.yScale, duration: duration)
//                        let grow = SKAction.group([growX, growY])
//                        grow.timingMode = .EaseOut
//                        kittenCropNode.runAction(shrink, completion: {
//                            if timeSpent < 12 {
//                                kittenCropNode.runAction(grow, completion: {
//                                    let newTimeSpent = timeSpent + 1
//                                    recurse(newTimeSpent)
//                                })
//                            }
//                        })
//                        
//                    }
//                }
//                
//                recurse(0)
//            })
//            cropped2.runAction(SKAction.fadeInWithDuration(0.57), completion: {
//                let newtexture = SKTexture(imageNamed: self.being.skin)
//                newtexture.filteringMode = SKTextureFilteringMode.Nearest
//
//                func presentCat(size: CGSize) {
//                    self.sprite.zPosition = 801;
//                    self.isKitten = false
//                    self.sprite.changeTextureTo(self.currentSkin())         
//                    
//                    cropped1.runAction(SKAction.fadeOutWithDuration(0.57))
//                    cropped2.runAction(SKAction.fadeOutWithDuration(0.57), completion: {
//                        tempBG.runAction(SKAction.fadeOutWithDuration(0.57), completion: {
//                            self.sprite.zPosition = 100;
//                            self.isBusy = false
//                            self.addActivity(self.flyTo(CGPoint(x: self.world.floor!.frame.midX, y: self.world.floor!.frame.midY)), priority: 0)
//                            if !previouslyFocused { // unfocus if unfocused prior to puberty
//                                self.isFocusedOn = false
//                            }
//                        })
//                    })
//                }
//                
//                func recurse(timeSpent: Int) {
//                    if timeSpent < 13 {
//                        let duration: NSTimeInterval = (14 - Double(timeSpent))/30
//                        let shrink = SKAction.scaleTo(0, duration: duration)
//                        shrink.timingMode = .EaseIn
//                        let growX = SKAction.scaleXTo(self.sprite.xScale, duration: duration)
//                        let growY = SKAction.scaleYTo(self.sprite.yScale, duration: duration)
//                        let grow = SKAction.group([growX, growY])
//                        grow.timingMode = .EaseOut
//                        grownCatCropNode.runAction(grow, completion: {
//                            if timeSpent < 12 {
//                                grownCatCropNode.runAction(shrink, completion: {
//                                    let newTimeSpent = timeSpent + 1
//                                    recurse(newTimeSpent)
//                                })
//                            } else {
//                                let growX2 = SKAction.scaleXTo(self.sprite.xScale, duration: 0.1)
//                                let growY2 = SKAction.scaleYTo(self.sprite.yScale, duration: 0.1)
//                                let grow2 = SKAction.group([growX2, growY2])
//                                grownCatCropNode.runAction(grow2, completion: {
//                                    presentCat(CGSize(width: grownCatCropNode.maskNode!.frame.width,
//                                        height: grownCatCropNode.maskNode!.frame.height))
//                                })
//                            }
//                        })
//                    }
//                }
//                
//                recurse(0)
//            })
//        })
//        print("\(being.name) pubed.")
//    }
//    
//    func die() {
//        isFocusedOn = false
//        isBusy = true
//        isAlive = false
//        let flip = SKAction.rotateByAngle(3.14, duration: 1)
//        let dissapear = SKAction.fadeAlphaTo(0, duration: 0.5)
//        let die = SKAction.sequence([flip, dissapear])
//       
//
//        sprite.runAction(die)
//        
//        print("\(being.name) died.")
//    }
//    
//    func flyTo(point: CGPoint) -> SKAction {
//        let velocity: Double = 150 //arbitrary speed of cat
//        let xDist: Double = Double(point.x - sprite.position.x)
//        let yDist: Double = Double(point.y - sprite.position.y)
//        let distance: Double = sqrt((xDist * xDist) + (yDist * yDist))
//        let time: NSTimeInterval = distance/velocity //so time is dependent on distance
//        
//        
//        if point.x > sprite.position.x { // face right
//            sprite.xScale = -46/9
//        } else if point.x < sprite.position.x { // face left
//            sprite.xScale = 46/9
//        }
//        let liftLegs = SKAction.runBlock({
//            let texture = SKTexture(imageNamed: self.currentSkin()+"_floating")
//            texture.filteringMode = SKTextureFilteringMode.Nearest
//            self.sprite.texture = texture
//        })
//        let fly = SKAction.moveTo(point, duration: time)
//        let lowerLegs = SKAction.runBlock({
//            let texture = SKTexture(imageNamed: self.currentSkin())
//            texture.filteringMode = SKTextureFilteringMode.Nearest
//            self.sprite.texture = texture
//        })
//        
//        return SKAction.sequence([liftLegs,fly,lowerLegs])
//    }
//    
//    func prance() {
//        /* Go to random point on floor */
//        
//        let randomX: Int
//        let randomY: Int
//        if isKitten {
//            randomX = randomInRange(Int(CGRectGetMinX(world.floor!.frame)+41), hi: Int(CGRectGetMaxX(world.floor!.frame)-41))
//            randomY = randomInRange(Int(CGRectGetMinY(world.floor!.frame)), hi: Int(CGRectGetMaxY(world.floor!.frame)-26))// Int(CGRectGetMaxY(world.floor.frame)+15)
//        } else {
//            randomX = randomInRange(Int(CGRectGetMinX(world.floor!.frame)+93), hi: Int(CGRectGetMaxX(world.floor!.frame)-93))
//            randomY = randomInRange(Int(CGRectGetMinY(world.floor!.frame)), hi: Int(CGRectGetMaxY(world.floor!.frame)-31))
//        }
//        
//        // y coordinate between MinY (top) and MidY (middle):
//        let randomPoint = CGPoint(x: randomX, y: randomY)
//        
//        addActivity(flyTo(randomPoint), priority: 10)
//        
//    }
//    
//    func currentSkin() -> String {
//        if isKitten {
//            return being.skin+"_kitten"
//        } else {
//            return being.skin
//        }
//    }
//    
//    func toggleFocus() {
//        if !isFocusing {
//            isFocusing = true
//            world.camera.runAction(SKAction.waitForDuration(0.7), completion: {
//                self.isFocusing = false
//            })
//            
//            if !isFocusedOn {
//                isFocusedOn = true
//                
//            } else {
//                isFocusedOn = false
//            }
//        }
//    }
//    
//    func update() {
//        if isAlive {
//            if isFocusedOn {
//                if world.camera.xScale != 0.7 {
//                    // zoom in
//                    if world.cameraIsZooming == false {
//                        world.cameraIsZooming = true
//                        let zoom = SKAction.scaleTo(0.7, duration: 1.1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0)
//                        world.camera.runAction(zoom, completion: {
//                            self.world.cameraIsZooming = false
//                        })
//                    }
//                    
//                }
//                if world.camera.position != CGPoint(x: sprite.position.x, y: sprite.frame.midY) {
//                    // pan
//                    let pan = SKAction.moveTo(CGPoint(x: sprite.position.x, y: sprite.frame.midY), duration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0)
//                    world.camera.runAction(pan)
//                }
//            } else {
//                if world.camera.xScale != 1 {
//                    let zoomNorm = SKAction.scaleTo(1, duration: 0.3)
//                    zoomNorm.timingMode = .EaseOut
//                    world.camera.runAction(zoomNorm)
//                }
//                if world.camera.position != CGPoint(x: world.scene!.frame.midX, y: world.scene!.frame.midY) {
//                    let center = CGPoint(x: world.scene!.frame.midX, y: world.scene!.frame.midY)
//                    let centerCam = SKAction.moveTo(center, duration: 0.2)
//                    world.camera.runAction(centerCam)
//                }
//            }
// 
//        }
//    }
//    
//    
//    
//}

class Cat: SKNode {
    var firstname: String!
    var skin: String!
    var sprite: SKPixelCatNode!
    var mood: String!
    var birthday: NSDate!
    let lifespan: NSTimeInterval = 1.minute
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
            randomX = Int.random(Int(CGRectGetMinX(world.floor.frame)+8)...Int(CGRectGetMaxX(world.floor.frame)-8))
            randomY = Int.random(Int(CGRectGetMinY(world.floor.frame))...Int(CGRectGetMaxY(world.floor.frame)-5))
        }
        
        let randomPoint = CGPoint(x: randomX, y: randomY)
        flyTo(randomPoint)
    }
    
    func pube() {
        
        print("\(firstname) pubed.")
        // maybe overlay rainbow overkitten and grow the size of the kitten texture to 
        // size of cat texture with it being a crop node, then fade in overlayed rainbow cat while fading out
        // kitten then fade the rainbow overlay?
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

