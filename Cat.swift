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

class Cat {
    
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
    //let family: FamilyTree
    
    init(name: String, skin: String, mood: String, weight: Float, inScene: SKScene) {
        self.scene = inScene;
        let daysAlive = NSTimeInterval(Int.random(10...15))
        self.name.firstName = "Test"
        self.name.lastName = "McTesterson"
        self.weight = 0.5
        self.skin = "oscar"
        self.mood = "Happy"
        self.sprite = SKPixelSpriteNode(textureName: skin+"_kitten")
        self.sprite.position = CGPoint(x: self.scene.frame.midX, y: self.scene.frame.midY)
        self.scene.addChild(self.sprite)
        self.birthday = NSDate()
        self.deathday = NSDate(timeInterval: daysAlive*3600*24, sinceDate: birthday)
        self.lifespan = daysAlive
        let birth = Activity(action: SKAction.scaleBy(10, duration: 5), priority: 0)
        self.todoQueue = PriorityQueue(ascending: true, startingValues: [birth])
    
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
                    print(action.description)
                    sprite.runAction(action, completion: {
                        print("finished action")
                        self.todoQueue.pop()
                        self.isBusy = false
                    })
                } else {
                    print("hmmmm.. \(self.name) has things to do but cannot do them.")
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
        
        print("-------- Cat Info -------")
        print("name: \(name)")
        print("skin: \(skin)")
        print("mood: \(mood)")
        print("age: \(age) years")
        print("life span: \(lifespan) years")
        print("life remaining: \(lifeLeft) years")
        print("weight: \(weight) lbs")
        print("birthday: \(simpleBirthDay)")
        print("deathday: \(simpleDeathDay)")
    }
    
    func die() {
        isAlive = false
        print("\(name) died.")
    }
    
}