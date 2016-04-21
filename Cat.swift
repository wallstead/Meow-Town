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
    var isAlive = true
    var todoQueue: PriorityQueue<Activity>
    var isBusy = false
    let scene: SKScene
    let sprite: SKSpriteNode
    var familyNode: TreeNode<Cat>?
    
    init(name: String, skin: String, mood: String, weight: Float, inScene: SKScene) {
        self.scene = inScene;
        let daysAlive = NSTimeInterval(10)
        self.name.firstName = name
        self.name.lastName = "McTesterson"
        self.weight = 0.5
        self.skin = "oscar"
        self.mood = "Happy"
        self.sprite = SKPixelSpriteNode(textureName: skin)
        self.sprite.zPosition = 100;
        self.sprite.position = CGPoint(x: self.scene.frame.midX, y: self.scene.frame.midY)
        self.scene.addChild(self.sprite)
        self.birthday = NSDate()
        self.deathday = NSDate(timeInterval: daysAlive*3600*24, sinceDate: birthday)
        self.lifespan = daysAlive
        let birth = Activity(action: SKAction.scaleBy(4, duration: 0.24), priority: 0)
        self.todoQueue = PriorityQueue(ascending: true, startingValues: [birth])
        self.familyNode = TreeNode(value: self)
    
        // TODO: find a better way to keep internal clock
        sprite.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock({
            self.doThings()
//            self.printInfo()
            self.trackAge()
        }), SKAction.waitForDuration(1)])))

        doThings()
        trackAge()
    }
    
    func trackAge() {
        if isAlive {
            let secondsAged = NSDate().timeIntervalSinceDate(birthday)
            age = secondsAged/86400
            
            if (lifespan-age <= 0) {
                die()
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
                } else { print("\(self.name) has things to do but cannot do them.") }
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
        
        print("-------- Cat Info -------")
        print("name: \(name.firstName)")
        print("skin: \(skin)")
        print("mood: \(mood)")
        print("age: \(age) years")
        print("life span: \(lifespan) years")
        if isAlive {
            print("life remaining: \(lifeLeft) years")
        } else {
            print("life remaining: 0")

        }
        print("weight: \(weight) lbs")
        print("birthday: \(simpleBirthDay)")
        print("deathday: \(simpleDeathDay)")
    }
    
    func die() {
        let flip = SKAction.rotateByAngle(3.14, duration: 1)
        let dissapear = SKAction.fadeAlphaTo(0, duration: 0.5)
        let die = SKAction.sequence([flip, dissapear])
        
        addActivity(die, priority: 0)
        
        let waitToDie = SKAction.waitForDuration(1.5)
        sprite.runAction(waitToDie, completion: {
            self.isAlive = false
        })
        
        print("\(name) died.")
    }
}

extension Cat: CustomStringConvertible {
    public var description: String {
        return name.firstName! + " " + name.lastName!
    }
}