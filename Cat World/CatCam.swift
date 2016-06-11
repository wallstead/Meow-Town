//
//  CatCam.swift
//  Cat World
//
//  Created by Willis Allstead on 6/7/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class CatCam: SKCameraNode {
    var currentFocus: Cat?
    var focusing: Bool!
    var camFrame: CGRect!
    
    // MARK: Initialization
    
    convenience init(withFrame frame: CGRect) {
        self.init()
        self.camFrame = frame
        self.focusing = false
        showHUD()
    }
    
    func toggleFocus(cat: Cat) {
        if currentFocus == cat { // unfocus
            if !focusing {
                currentFocus = nil
                unfocus()
            }
        } else { // focus
            if !focusing {
                let zoom = SKAction.scaleTo(0.75, duration: 0.5)
                zoom.timingMode = .EaseOut
                self.runAction(zoom)
                currentFocus = cat
            }
        }
        
    }
    
    func showHUD() {
        let topBar = SKPixelSpriteNode(textureName: "topbar_center")
        let menuButton = SKPixelToggleButtonNode(textureName: "topbar_menubutton")
        let itemsButton = SKPixelToggleButtonNode(textureName: "topbar_itemsbutton")
        
        let scale = GameScene.current.frame.width/(topBar.frame.width+menuButton.frame.width+itemsButton.frame.width)
    
        topBar.zPosition = 200
        menuButton.zPosition = 200
        itemsButton.zPosition = 200
        
        topBar.setScale(scale)
        topBar.position.y = camFrame.maxY-topBar.frame.height/2
        menuButton.setScale(scale)
        menuButton.position.x = camFrame.minX+menuButton.frame.width/2
        menuButton.position.y = topBar.position.y
        itemsButton.setScale(scale)
        itemsButton.position.x = camFrame.maxX-itemsButton.frame.width/2
        itemsButton.position.y = topBar.position.y
        
        self.addChild(topBar)
        self.addChild(menuButton)
        self.addChild(itemsButton)
        
        
//        let menu = Menu(topBar: topBar)
//        menu.zPosition = 100
//        menu.setScale(scale)
//        self.addChild(menu)
    }
    
    func unfocus() {
        self.removeAllActions()
        let resetPosition = SKAction.moveTo(GameScene.current.frame.mid(), duration: 0.5)
        resetPosition.timingMode = .EaseOut
        self.runAction(resetPosition)
        let zoom = SKAction.scaleTo(1, duration: 0.5)
        zoom.timingMode = .EaseOut
        self.runAction(zoom)
    }
    
    func update(currentTime: CFTimeInterval) {
        if currentFocus != nil {
            var point = currentFocus!.sprite.positionInScene
            if currentFocus!.isKitten() {
                point.y += 40
            } else {
                point.y += 70
            }
            let action = SKAction.moveTo(point, duration: 0.25)
            self.runAction(action)
        }
    }
    
    func displayCatSelection() {
        print(self.frame.height)
        
        var isShiftingCats = false
        var catSpriteArray: [SKPixelSpriteNode] = []
        var currentCatSprite: SKPixelSpriteNode
        
        let background = SKPixelSpriteNode(textureName: "catselect_bg")
        background.setScale(GameScene.current.frame.width/background.frame.width)
        background.zPosition = 1000
        background.alpha = 0
        self.addChild(background)
        
        let cats = PlistManager.sharedInstance.getValueForKey("Selectable Cats") as! NSDictionary
        for cat in cats {
            let catSkin = cat.value.valueForKey("skin") as! String
            catSpriteArray.append(SKPixelSpriteNode(textureName: catSkin))
            print(catSkin)
        }
        currentCatSprite = catSpriteArray[0]
        
        let titleBar = SKPixelSpriteNode(textureName: "catselect_titlebar")
        background.addChild(titleBar)
        titleBar.zPosition = 10
        titleBar.position = titleBar.convertPoint(CGPoint(x: 0, y:self.frame.maxY), fromNode: self)
        titleBar.position.y -= titleBar.frame.height/2

        let title = SKLabelNode(fontNamed: "Fipps-Regular")
        titleBar.addChild(title)
        title.zPosition = 1
        title.text = "FAT FELINE"
        title.setScale(1/10)
        title.fontSize = 80
        title.fontColor = SKColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        title.verticalAlignmentMode = .Center

        let circleBackground = SKPixelSpriteNode(textureName: "catselect_circle")
        background.addChild(circleBackground)
        circleBackground.zPosition = 10
        circleBackground.position.y -= 5
        
        let circleCropNode = SKCropNode()
        background.addChild(circleCropNode)
        circleCropNode.zPosition = 11
        circleCropNode.position = circleBackground.position
        circleCropNode.maskNode = SKPixelSpriteNode(textureName: "catselect_circle_mask")
        
        let description = SKLabelNode(fontNamed: "Silkscreen")
        background.addChild(description)
        description.zPosition = 10
        description.text = "Pick A Cat"
        description.setScale(1/10)
        description.fontSize = 80
        description.position.y = circleBackground.frame.maxY+7
        description.fontColor = SKColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        description.verticalAlignmentMode = .Center
        
        for cat in catSpriteArray {
            circleCropNode.addChild(cat)
            cat.position = CGPoint(x: (catSpriteArray.indexOf(cat)!*55), y: 0)
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
        let rightButton = SKPixelButtonNode(textureName: "catselect_arrow")

        func updateButtons() {
            if catSpriteArray.indexOf(currentCatSprite) == 0 {
                leftButton.runAction(SKAction.fadeAlphaTo(0.5, duration: 0.5))
                rightButton.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
                leftButton.userInteractionEnabled = false
                rightButton.userInteractionEnabled = true
            } else if catSpriteArray.indexOf(currentCatSprite) == catSpriteArray.count - 1 {
                leftButton.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
                rightButton.runAction(SKAction.fadeAlphaTo(0.5, duration: 0.5))
                leftButton.userInteractionEnabled = true
                rightButton.userInteractionEnabled = false
            } else {
                leftButton.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
                rightButton.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
                leftButton.userInteractionEnabled = true
                rightButton.userInteractionEnabled = true
            }
        }
        
        background.addChild(leftButton)
        leftButton.zPosition = 12
        leftButton.position.x = circleBackground.frame.minX-7
        leftButton.action = {
            if !isShiftingCats && catSpriteArray.indexOf(currentCatSprite) > 0  {
                currentCatSprite = catSpriteArray[catSpriteArray.indexOf(currentCatSprite)!-1]
                updateButtons()
                for cat in catSpriteArray {
                    cat.runAction(shift(left: false), completion: {
                        if catSpriteArray.indexOf(cat) == catSpriteArray.count-1 {
                            isShiftingCats = false
                        }
                    })
                }
            }
        }

        background.addChild(rightButton)
        rightButton.zPosition = 12
        rightButton.position.x = circleBackground.frame.maxX+7
        rightButton.xScale = -1
        rightButton.action = {
            if !isShiftingCats && catSpriteArray.indexOf(currentCatSprite) < catSpriteArray.count - 1  {
                currentCatSprite = catSpriteArray[catSpriteArray.indexOf(currentCatSprite)!+1]
                updateButtons()
                for cat in catSpriteArray {
                    cat.runAction(shift(left: true), completion: {
                        if catSpriteArray.indexOf(cat) == catSpriteArray.count-1 {
                            isShiftingCats = false
                        }
                    })
                }
            }
        }

        let doneButton = SKPixelButtonNode(textureName: "catselect_done", text: "Mine!")
        background.addChild(doneButton)
        doneButton.zPosition = 12
        doneButton.position.y = circleBackground.frame.minY-11
        doneButton.action = {
            isShiftingCats = true
            GameScene.current.world.addCat(currentCatSprite.textureName)
            background.runAction(SKAction.fadeAlphaTo(0, duration: 0.5), completion: {
                background.removeFromParent()
            })
        }
        
        background.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        
        updateButtons()
    }
}