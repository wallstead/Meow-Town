//
//  World.swift
//  Cat World
//
//  Created by Willis Allstead on 4/29/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class NewWorld: SKNode {
    var wallpaper: SKPixelSpriteNode!
    var floor: SKPixelSpriteNode!
    var cats: [NewCat]!
    override var description: String { return "*** World ***\ncats: \(cats)" }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.wallpaper = decoder.decodeObjectForKey("wallpaper") as! SKPixelSpriteNode
        self.floor = decoder.decodeObjectForKey("floor") as! SKPixelSpriteNode
        self.cats = decoder.decodeObjectForKey("cats") as! [NewCat]
        
        layout()
        
        if self.cats.isEmpty {
            displayCatSelection()
        }
    }
    
    convenience init(name: String) {
        self.init()
        self.wallpaper = SKPixelSpriteNode(textureName: "wallpaper")
        self.floor = SKPixelSpriteNode(textureName: "floor")
        self.cats = []
        
        layout()
        
        displayCatSelection()
    }
    
    override func encodeWithCoder(coder: NSCoder) {
        if let wallpaper = wallpaper { coder.encodeObject(wallpaper, forKey: "wallpaper") }
        if let floor = floor { coder.encodeObject(floor, forKey: "floor") }
        if let cats = cats { coder.encodeObject(cats, forKey: "cats") }
    }
    
    func save() {
        let worldData = NSKeyedArchiver.archivedDataWithRootObject(self)
        PlistManager.sharedInstance.saveValue(worldData, forKey: "World")
    }
    
    func layout() {
        wallpaper.setScale(46/9)
        wallpaper.zPosition = 0
        floor.setScale(46/9)
        floor.zPosition = 1
        floor.position = CGPoint(x: wallpaper.frame.midX, y: wallpaper.frame.minY+(floor!.frame.height/2))
        
        self.addChild(self.wallpaper)
        self.addChild(self.floor)
    }
    
    func addCat(name: String) {
        let testCat = NewCat(name: "Oscar", skin: "oscar", mood: "happy", birthday: NSDate(), world: self)
        cats.append(testCat)
        save()
    }
    
    func displayCatSelection() {
        var isShiftingCats = false
        var catSpriteArray: [SKPixelSpriteNode] = []
        var currentCatSprite: SKPixelSpriteNode

        let background = SKPixelSpriteNode(textureName: "catselect_bg")
        background.setScale(46/9)
        background.zPosition = 10000
        background.alpha = 0
        
        let cats = PlistManager.sharedInstance.getValueForKey("Selectable Cats") as! NSDictionary
        for cat in cats {
            let catSkin = cat.value.valueForKey("skin") as! String
            catSpriteArray.append(SKPixelSpriteNode(textureName: catSkin))
            print(catSkin)
        }
        currentCatSprite = catSpriteArray[0]
        
        let titleBar = SKPixelSpriteNode(textureName: "catselect_titlebar")
        titleBar.setScale(46/9)
        titleBar.zPosition = 10001
        titleBar.position = CGPoint(x: wallpaper.frame.midX, y: wallpaper.frame.maxY-titleBar.frame.height/2)
        titleBar.alpha = 0
        
        let title = SKLabelNode(fontNamed: "Fipps-Regular")
        title.zPosition = 10002
        title.text = "FAT FELINE"
        title.setScale(5/10)
        title.fontSize = 80
        title.position = titleBar.position
        title.fontColor = SKColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        title.verticalAlignmentMode = .Center
        title.alpha = 0
        
        let description = SKLabelNode(fontNamed: "Silkscreen")
        description.zPosition = 10002
        description.text = "Pick A Cat"
        description.setScale(5/10)
        description.fontSize = 80
        description.position.y = title.position.y-140
        description.fontColor = SKColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        description.verticalAlignmentMode = .Center
        description.alpha = 0
        
        let circleBackground = SKPixelSpriteNode(textureName: "catselect_circle")
        circleBackground.setScale(46/9)
        circleBackground.zPosition = 10002
        circleBackground.alpha = 0
        
        let circleCropNode = SKCropNode()
        circleCropNode.position = circleBackground.position
        circleCropNode.maskNode = SKPixelSpriteNode(textureName: "catselect_circle_mask")
        circleCropNode.setScale(46/9)
        circleCropNode.zPosition = 10003
        circleCropNode.alpha = 0
        
        for cat in catSpriteArray {
            print(cat)
            print(catSpriteArray.indexOf(cat)!*55)
            cat.alpha = 0
            circleCropNode.addChild(cat)
            cat.position = CGPoint(x: (catSpriteArray.indexOf(cat)!*55), y: 0)
            cat.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        }
        
        func shift(left l: Bool) -> SKAction {
            isShiftingCats = true
            var multiplier: CGFloat = 1
            if l {
                multiplier = -1
            }
            return SKAction.moveByX(multiplier*55, y: 0, duration: 0.5, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0)
        }
        
        let leftButton = SKPixelButtonNode(textureName: "catselect_arrow")
        leftButton.setScale(46/9)
        leftButton.zPosition = 10010
        leftButton.position = CGPoint(x: circleBackground.position.x-150, y: circleBackground.position.y)
        leftButton.alpha = 0
        leftButton.action = {
            if !isShiftingCats && catSpriteArray.indexOf(currentCatSprite) > 0  {
                for cat in catSpriteArray {
                    cat.runAction(shift(left: false), completion: {
                        if catSpriteArray.indexOf(cat) == catSpriteArray.count-1 {
                            currentCatSprite = catSpriteArray[catSpriteArray.indexOf(currentCatSprite)!-1]
                            isShiftingCats = false
                        }
                    })
                }
            }
        }
        
        let rightButton = SKPixelButtonNode(textureName: "catselect_arrow")
        rightButton.setScale(46/9)
        rightButton.zPosition = 10010
        rightButton.position = CGPoint(x: circleBackground.position.x+150, y: circleBackground.position.y)
        rightButton.alpha = 0
        rightButton.xScale = -(46/9)
        rightButton.action = {
            if !isShiftingCats && catSpriteArray.indexOf(currentCatSprite) < catSpriteArray.count - 1  {
                for cat in catSpriteArray {
                    cat.runAction(shift(left: true), completion: {
                        if catSpriteArray.indexOf(cat) == catSpriteArray.count-1 {
                            currentCatSprite = catSpriteArray[catSpriteArray.indexOf(currentCatSprite)!+1]
                            isShiftingCats = false
                        }
                    })
                }
            }
        }
        
        let doneButton = SKPixelButtonNode(textureName: "catselect_done", text: "Mine!")
        doneButton.setScale(46/9)
        doneButton.zPosition = 10010
        doneButton.position.y = circleBackground.position.y-190
        doneButton.alpha = 0
        doneButton.action = {
            print(currentCatSprite.textureName)
        }
        
        background.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        titleBar.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        title.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        description.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        circleBackground.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        circleCropNode.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        doneButton.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        leftButton.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        rightButton.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        
        self.addChild(background)
        self.addChild(titleBar)
        self.addChild(title)
        self.addChild(description)
        self.addChild(circleBackground)
        self.addChild(circleCropNode)
        self.addChild(doneButton)
        self.addChild(leftButton)
        self.addChild(rightButton)
    }
    
//    func update() {
//        for cat in cats {
//            cat.update()
//        }
//    }
}

