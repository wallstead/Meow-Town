//
//  CatSelect.swift
//  Cat World
//
//  Created by Willis Allstead on 4/15/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class CatSelect: SKNode {
    var isShiftingCats = false
    var catSpriteArray: [SKPixelSpriteNode] = []
    let leftButton: SKPixelButtonNode
    let rightButton: SKPixelButtonNode
    var currentCatSprite: SKPixelSpriteNode
    let circleCropNode: SKCropNode
    
    init(inScene scene: SKScene) {
        let background = SKPixelSpriteNode(textureName: "catselect_bg", pressAction: {})
        let backgroundMusic = SKAudioNode(fileNamed: "mathgrant_calm.mp3")
        backgroundMusic.positional = false
        
        // TODO: load list of cats and populate array here
        catSpriteArray.append(SKPixelSpriteNode(textureName: "oscar", pressAction: {}))
        catSpriteArray.append(SKPixelSpriteNode(textureName: "oscar_kitten", pressAction: {}))
        catSpriteArray.append(SKPixelSpriteNode(textureName: "delphi", pressAction: {}))
        
        currentCatSprite = catSpriteArray[0]
        
        let titleBar = SKPixelSpriteNode(textureName: "catselect_titlebar", pressAction: {})
        let circleBackground = SKPixelSpriteNode(textureName: "catselect_circle", pressAction: {})
        
//        let catForDisplay = currentCatSprite
//        catForDisplay2.position = CGPoint(x: 55, y: 0)

        leftButton = SKPixelButtonNode(buttonImage: "catselect_arrow", buttonText: nil, buttonAction: {})
        rightButton = SKPixelButtonNode(buttonImage: "catselect_arrow", buttonText: nil, buttonAction: {})
        rightButton.xScale = -1
        let doneButton = SKPixelButtonNode(buttonImage: "catselect_done", buttonText: "Done", buttonAction: {})
        
        circleCropNode = SKCropNode()
        circleCropNode.maskNode = SKPixelSpriteNode(textureName: "catselect_circle_mask", pressAction: {})
        
        let title = SKLabelNode(fontNamed: "Fipps-Regular")
        title.text = "FAT FELINE"
        title.setScale(1/10)
        title.fontSize = 80
        title.fontColor = SKColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        title.verticalAlignmentMode = .Center
        
        let description = SKLabelNode(fontNamed: "Silkscreen")
        description.text = "Pick A Cat"
        description.setScale(1/10)
        description.fontSize = 80
        description.fontColor = SKColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        description.verticalAlignmentMode = .Center
        description.alpha = 0
        
        super.init()
        self.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        self.setScale(46/9)// for iphone 6s+
        self.zPosition = 1000
        background.zPosition = 0
        description.zPosition = 1
        circleBackground.zPosition = 3
        circleCropNode.zPosition = 4
        leftButton.zPosition = 3
        rightButton.zPosition = 3
        doneButton.zPosition = 3
        titleBar.zPosition = 5
        title.zPosition = 6
        
        leftButton.action = {
            print("left")
            if !self.isShiftingCats {
                self.isShiftingCats = true
                
                self.currentCatSprite = self.catSpriteArray[self.catSpriteArray.indexOf(self.currentCatSprite)!-1]
                self.updateButtons()
                for cat in self.catSpriteArray {
                    cat.runAction(self.shift(left: false), completion: {
                        self.isShiftingCats = false
                    })
                }
            }
        }
        
        rightButton.action = {
            print("right")
            if !self.isShiftingCats {
                self.isShiftingCats = true
                self.currentCatSprite = self.catSpriteArray[self.catSpriteArray.indexOf(self.currentCatSprite)!+1]
                self.updateButtons()
                for cat in self.catSpriteArray {
                    cat.runAction(self.shift(left: true), completion: {
                        self.isShiftingCats = false
                    })
                }
            }
        }
        
        doneButton.action = {
            self.runAction(SKAction.fadeOutWithDuration(0.5))
        }
        
        
        titleBar.position = CGPoint(x: background.frame.midX, y: background.frame.maxY-titleBar.frame.height/2)
        title.position = CGPoint(x: titleBar.frame.midX, y: titleBar.frame.midY)
        circleCropNode.position = circleBackground.position
        leftButton.position = CGPoint(x: circleBackground.frame.minX-5, y: circleBackground.frame.midY)
        rightButton.position = CGPoint(x: circleBackground.frame.maxX+5, y: circleBackground.frame.midY)
        doneButton.position = CGPoint(x: circleBackground.frame.midX, y: circleBackground.frame.minY-11)
        
        self.addChild(background)
        self.addChild(titleBar)
        self.addChild(description)
        self.addChild(circleBackground)
        self.addChild(circleCropNode)
        self.addChild(leftButton)
        self.addChild(rightButton)
        self.addChild(doneButton)
        self.addChild(title)
        self.addChild(backgroundMusic)
        
//        circleCropNode.addChild(catForDisplay)
        
        
        let displayDescription = SKAction.group([SKAction.fadeInWithDuration(0.7),
                                 SKAction.moveToY(circleBackground.frame.maxY+8, duration: 0.7)])
        displayDescription.timingMode = .EaseOut
        description.runAction(displayDescription)
        
        displayCats()
        updateButtons()
    }
    
    func displayCats() { // display all cats in a single row for moving through
        for cat in catSpriteArray {
            cat.position = CGPoint(x: 0+(catSpriteArray.indexOf(cat)!*55), y: 0)
            circleCropNode.addChild(cat)
        }
    }
    
    func updateButtons() {
        
        if catSpriteArray.indexOf(currentCatSprite) == 0 { // if displaying first cat, disable left
            leftButton.userInteractionEnabled = false
            rightButton.userInteractionEnabled = true
            leftButton.runAction(SKAction.fadeAlphaTo(0.5, duration: 0.2))
        } else if catSpriteArray.indexOf(currentCatSprite) == catSpriteArray.count-1 { // if displaying last cat, disable right
            leftButton.userInteractionEnabled = true
            rightButton.userInteractionEnabled = false
            rightButton.runAction(SKAction.fadeAlphaTo(0.5, duration: 0.2))
        } else {// if neither, display both
            leftButton.userInteractionEnabled = true
            rightButton.userInteractionEnabled = true
            leftButton.runAction(SKAction.fadeAlphaTo(1, duration: 0.2))
            rightButton.runAction(SKAction.fadeAlphaTo(1, duration: 0.2))
        }
    }
    
    func shift(left left: Bool) -> SKAction {
        var multiplier: CGFloat = 1
        if left {
            multiplier = -1
        }
        let slide = SKAction.moveByX(multiplier*55, y: 0, duration: 0.5, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0)
        return slide
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}