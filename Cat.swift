//
//  Cat.swift
//  Cat World
//
//  Created by Willis Allstead on 4/7/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class Activity: Comparable {
    let action: SKAction
    let priority: Int
    
    init(action: SKAction, priority: Int) {
        self.action = action
        self.priority = priority
    }
}

func < (lhs: Activity, rhs: Activity) -> Bool {
    return lhs.priority < rhs.priority
}

func == (lhs: Activity, rhs: Activity) -> Bool {
    return lhs.priority == rhs.priority
}

public class Cat {
    
    var name: (firstName: String?, lastName: String?)
    let skin: String
    var mood: String
    var age: NSTimeInterval = 0
    var weight: Float
    let birthday: NSDate
    var deathday: NSDate
    let lifespan: NSTimeInterval
    
    let world: World
    let sprite: SKPixelSpriteNode
    var familyNode: TreeNode<Cat>?
    var todoQueue: PriorityQueue<Activity>
    
    var isBusy = false
    var isAlive = true
    var isFocusedOn = false
    var isKitten = true
    
    init(name: String, skin: String, mood: String, weight: Float, inWorld: World) {
        self.world = inWorld;
        // 0.04166666667 = 1 hour in real time
        // 0.01041666667 = 15 minutes in real time
        // 0.003472222223 = 5 minutes in real time
        // 0.0006944444446 = 1 minute in real time
        // 0.0003472222223 = 30 seconds in real time
        let daysAlive = NSTimeInterval(0.003472222223)
        self.name.firstName = name
        self.name.lastName = "McTesterson"
        self.weight = 0.5
        self.skin = skin
        self.mood = "Happy"
        self.sprite = SKPixelSpriteNode(textureName: skin+"_kitten", pressAction: {})
        self.sprite.zPosition = 100
        self.sprite.position = CGPoint(x: self.world.frame.midX, y: self.world.frame.midY)
        self.sprite.userInteractionEnabled = true
        self.world.addChild(self.sprite)
        self.birthday = NSDate()
        self.deathday = NSDate(timeInterval: daysAlive*3600*24, sinceDate: birthday)
        self.lifespan = daysAlive
        self.sprite.setScale(46/9)
//        let birth = Activity(action: SKAction.scaleBy(46/9, duration: 0.24), priority: 0)
        self.todoQueue = PriorityQueue(ascending: true, startingValues: [])
        self.familyNode = TreeNode(value: self)
    
        // TODO: find a better way to keep internal clock
        sprite.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock({
            self.doThings()
            self.trackAge()
        }), SKAction.waitForDuration(1)])))

        doThings()
        trackAge()
        
        sprite.pressAction = {
            self.printInfo()
//            if !self.isFocusedOn {
//                let zoomIn = SKAction.scaleTo(0.6, duration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0)
//                let findCat = SKAction.moveTo(self.sprite.position, duration: 0.3)
//                self.world.camera!.runAction(SKAction.group([zoomIn,findCat]), completion: {
//                    self.isFocusedOn = true
//                })
//            } else {
//                let zoomNorm = SKAction.scaleTo(1, duration: 0.3)
//                zoomNorm.timingMode = .EaseOut
//                let center = CGPoint(x: self.scene.frame.midX, y: self.scene.frame.midY)
//                let centerCam = SKAction.moveTo(center, duration: 0.3)
//                self.scene.camera!.runAction(SKAction.group([zoomNorm,centerCam]), completion: {
//                    self.isFocusedOn = false
//                })
//            }
            
        }
    }
    
    func trackAge() {
        
        if isAlive {
            let secondsAged = NSDate().timeIntervalSinceDate(birthday)
            age = secondsAged/86400
            
            if (lifespan-age <= 0) {
                die()
            }
            
            // cats are kittens for 1 year out of their lives (about 1/15 of their lifetime)
            if (isKitten && age >= lifespan/60 && todoQueue.isEmpty && !isBusy) {
                pube()
            }
        }
    }
    
    func doThings() {
        if isAlive {
            if !todoQueue.isEmpty && !isBusy {
                isBusy = true
                if let action = todoQueue.peek()?.action {
                    sprite.runAction(action, completion: {
                        self.todoQueue.pop()
                        self.isBusy = false
                    })
//                    if self.isFocusedOn {
//                        self.scene.camera?.runAction(action)
//                    }
                } else { print("\(self.name) has things to do but cannot do them.") }
            } else if todoQueue.isEmpty && !isBusy {
                let randomNumber = randomPercent()
                switch(randomNumber) {
                    
                case 0..<50:
                    prance()
                default:
                    print("You dont move around")
                }

            }
        } else { print("dead men do no things.") }
    }
    
    func addActivity(action: SKAction, priority: Int) {
        todoQueue.push(Activity(action: action, priority: priority))
    }
    
    func printInfo() {
        let simpleBirthDay: String = NSDateFormatter.localizedStringFromDate(birthday, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        let simpleDeathDay: String = NSDateFormatter.localizedStringFromDate(deathday, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        let lifeLeft = lifespan-age
        
        let numberOfPlaces = 5.0
        let multiplier = pow(10.0, numberOfPlaces)
        
        print("-------- Cat Info -------")
        print("name: \(name.firstName)")
        print("skin: \(skin)")
        print("mood: \(mood)")
        print("age: \(round(age * multiplier) / multiplier) years")
        print("life span: \(round(lifespan * multiplier) / multiplier) years")
        if isAlive {
            print("life remaining: \(round(lifeLeft * multiplier) / multiplier) years")
        } else {
            print("life remaining: 0")

        }
        print("weight: \(weight) lbs")
        print("birthday: \(simpleBirthDay)")
        print("deathday: \(simpleDeathDay)")
    }
    
    
    func pube() {
        isBusy = true
        /* cover non-ui parts with black */
        let tempBG = SKSpriteNode(color: SKColor.blackColor(), size: world.wallpaper.size)
        tempBG.position = world.wallpaper.position
        tempBG.zPosition = 800
        tempBG.alpha = 0
        sprite.zPosition = 801
        
        world.addChild(tempBG)
        
        let cropped1 = SKSpriteNode(color: SKColor.whiteColor(), size: self.world.wallpaper.size)
        cropped1.alpha = 0
        let cropped2 = SKSpriteNode(color: SKColor.whiteColor(), size: self.world.wallpaper.size)
        cropped2.alpha = 0
        
        let kittenCropNode = SKCropNode()
        kittenCropNode.maskNode = SKPixelSpriteNode(textureName: self.skin+"_kitten", pressAction: {})
        kittenCropNode.xScale = self.sprite.xScale
        kittenCropNode.yScale = self.sprite.yScale
        kittenCropNode.zPosition = 802
        kittenCropNode.addChild(cropped1)
        kittenCropNode.position = self.sprite.position
        kittenCropNode.alpha = 1
        
        let grownCatCropNode = SKCropNode()
        grownCatCropNode.maskNode = SKPixelSpriteNode(textureName: self.skin, pressAction: {})
        grownCatCropNode.xScale = 0
        grownCatCropNode.yScale = 0
        grownCatCropNode.zPosition = 802
        grownCatCropNode.addChild(cropped2)
        grownCatCropNode.position = self.sprite.position
        grownCatCropNode.alpha = 1
        
        
        self.world.addChild(kittenCropNode)
        self.world.addChild(grownCatCropNode)

        // TODO: do all of this better
        tempBG.runAction(SKAction.fadeInWithDuration(0.57), completion: {
            /* Add a white node the size of the floor which will be used as a crop of the others */
            cropped1.runAction(SKAction.fadeInWithDuration(0.57), completion: {
                self.sprite.zPosition = 100;
                func recurse(timeSpent: Int) {
                    if timeSpent < 13 {
                        let duration: NSTimeInterval = (14 - Double(timeSpent))/30
                        let shrink = SKAction.scaleTo(0, duration: duration)
                        shrink.timingMode = .EaseIn
                        let growX = SKAction.scaleXTo(self.sprite.xScale, duration: duration)
                        let growY = SKAction.scaleYTo(self.sprite.yScale, duration: duration)
                        let grow = SKAction.group([growX, growY])
                        grow.timingMode = .EaseOut
                        kittenCropNode.runAction(shrink, completion: {
                            if timeSpent < 12 {
                                kittenCropNode.runAction(grow, completion: {
                                    let newTimeSpent = timeSpent + 1
                                    recurse(newTimeSpent)
                                })
                            }
                        })
                        
                    }
                }
                
                recurse(0)
            })
            cropped2.runAction(SKAction.fadeInWithDuration(0.57), completion: {
                let newtexture = SKTexture(imageNamed: self.skin)
                newtexture.filteringMode = SKTextureFilteringMode.Nearest

                func presentCat(size: CGSize) {
                    self.sprite.zPosition = 801;
                    self.isKitten = false
                    self.sprite.changeTextureTo(self.currentSkin())
//                    
                    
                    cropped1.runAction(SKAction.fadeOutWithDuration(0.57))
                    cropped2.runAction(SKAction.fadeOutWithDuration(0.57), completion: {
                        tempBG.runAction(SKAction.fadeOutWithDuration(0.57), completion: {
                            self.sprite.zPosition = 100;
                            self.isBusy = false
                        })
                    })
                }
                
                func recurse(timeSpent: Int) {
                    if timeSpent < 13 {
                        let duration: NSTimeInterval = (14 - Double(timeSpent))/30
                        let shrink = SKAction.scaleTo(0, duration: duration)
                        shrink.timingMode = .EaseIn
                        let growX = SKAction.scaleXTo(self.sprite.xScale, duration: duration)
                        let growY = SKAction.scaleYTo(self.sprite.yScale, duration: duration)
                        let grow = SKAction.group([growX, growY])
                        grow.timingMode = .EaseOut
                        grownCatCropNode.runAction(grow, completion: {
                            if timeSpent < 12 {
                                grownCatCropNode.runAction(shrink, completion: {
                                    let newTimeSpent = timeSpent + 1
                                    recurse(newTimeSpent)
                                })
                            } else {
                                let growX2 = SKAction.scaleXTo(self.sprite.xScale, duration: 0.1)
                                let growY2 = SKAction.scaleYTo(self.sprite.yScale, duration: 0.1)
                                let grow2 = SKAction.group([growX2, growY2])
                                grownCatCropNode.runAction(grow2, completion: {
                                    presentCat(CGSize(width: grownCatCropNode.maskNode!.frame.width,
                                        height: grownCatCropNode.maskNode!.frame.height))
                                })
                            }
                        })
                    }
                }
                
                recurse(0)
            })
        })
        print("\(name) pubed.")
    }
    
    func die() {
        isBusy = true
        isAlive = false
        let flip = SKAction.rotateByAngle(3.14, duration: 1)
        let dissapear = SKAction.fadeAlphaTo(0, duration: 0.5)
        let die = SKAction.sequence([flip, dissapear])
       

        sprite.runAction(die)
        
        print("\(name) died.")
    }
    
    func flyTo(point: CGPoint) -> SKAction {
        let velocity: Double = 150 //arbitrary speed of cat
        let xDist: Double = Double(point.x - sprite.position.x)
        let yDist: Double = Double(point.y - sprite.position.y)
        let distance: Double = sqrt((xDist * xDist) + (yDist * yDist))
        let time: NSTimeInterval = distance/velocity //so time is dependent on distance
        
        
        if point.x > sprite.position.x { // face right
            sprite.xScale = -46/9
        } else if point.x < sprite.position.x { // face left
            sprite.xScale = 46/9
        }
        let liftLegs = SKAction.runBlock({
            let texture = SKTexture(imageNamed: self.currentSkin()+"_floating")
            texture.filteringMode = SKTextureFilteringMode.Nearest
            self.sprite.texture = texture
        })
        let fly = SKAction.moveTo(point, duration: time)
        let lowerLegs = SKAction.runBlock({
            let texture = SKTexture(imageNamed: self.currentSkin())
            texture.filteringMode = SKTextureFilteringMode.Nearest
            self.sprite.texture = texture
        })
        
        return SKAction.sequence([liftLegs,fly,lowerLegs])
    }
    
    func prance() {
        /* Go to random point on floor */
        
        let randomX = randomInRange(Int(CGRectGetMinX(world.floor.frame)+90), hi: Int(CGRectGetMaxX(world.floor.frame)-91))
        // y coordinate between MinY (top) and MidY (middle):
        let randomY = randomInRange(Int(CGRectGetMinY(world.floor.frame)+57), hi: Int(CGRectGetMaxY(world.floor.frame)+15))
        let randomPoint = CGPoint(x: randomX, y: randomY)
        
        addActivity(flyTo(randomPoint), priority: 10)
        
    }
    
    func currentSkin() -> String {
        if isKitten {
            return skin+"_kitten"
        } else {
            return skin
        }
    }
    
    
}

extension Cat: CustomStringConvertible {
    public var description: String {
        return name.firstName! + " " + name.lastName!
    }
}