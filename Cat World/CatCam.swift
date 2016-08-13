//
//  CatCam.swift
//  Meow Town
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
    var catInfo: SKNode!
    var menu: Menu!
    var itemPanel: ItemPanel!
    var menuButton: SKPixelToggleButtonNode!
    var itemsButton: SKPixelToggleButtonNode!
    var topBar: SKPixelSpriteNode!
    
    // MARK: Initialization
    
    convenience init(withFrame frame: CGRect) {
        self.init()
        self.camFrame = frame
        self.focusing = false
        self.catInfo = SKNode()
        self.addChild(self.catInfo)
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
                let zoom = SKAction.scale(to: 0.75, duration: 0.5)
                zoom.timingMode = .easeOut
                self.run(zoom)
                currentFocus = cat
            }
        }
        DispatchQueue.main.async {
            self.toggleCatFocusInfo()
        }
    }
    
    func showHUD() {
        topBar = SKPixelSpriteNode(pixelImageNamed: "topbar_center")
        menuButton = SKPixelToggleButtonNode(pixelImageNamed: "topbar_menubutton")
        itemsButton = SKPixelToggleButtonNode(pixelImageNamed: "topbar_itemsbutton")
        
        GameScene.current.scale = GameScene.current.frame.width/(topBar.frame.width+menuButton.frame.width+itemsButton.frame.width)
    
        topBar.zPosition = 300
        menuButton.zPosition = 300
        itemsButton.zPosition = 300
        
        topBar.setScale(GameScene.current.scale)
        topBar.position.y = camFrame.maxY-topBar.frame.height/2
        menuButton.setScale(GameScene.current.scale)
        menuButton.position.x = camFrame.minX+menuButton.frame.width/2
        menuButton.position.y = topBar.position.y
        itemsButton.setScale(GameScene.current.scale)
        itemsButton.position.x = camFrame.maxX-itemsButton.frame.width/2
        itemsButton.position.y = topBar.position.y
        
        let calorieCount = SKLabelNode(fontNamed: "Silkscreen")
        calorieCount.zPosition = 1
        calorieCount.text = "Calories:"
        calorieCount.setScale(1/10)
        calorieCount.fontSize = 80
        calorieCount.fontColor = SKColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        calorieCount.verticalAlignmentMode = .center
        calorieCount.name = "scoreCount"
        //            catName.position.y =
        topBar.addChild(calorieCount)
        
        self.addChild(topBar)
        self.addChild(menuButton)
        self.addChild(itemsButton)
        
        
        
        menu = Menu(camFrame: camFrame, topBar: topBar)
        menu.zPosition = 200
        self.addChild(menu)
        
        itemPanel = ItemPanel(camFrame: camFrame, topBar: topBar)
        itemPanel.zPosition = 100
        self.addChild(itemPanel)
        
        
        menuButton.action = {
            self.menu.toggle()
        }
        
        itemsButton.action = {
            self.itemPanel.toggle()
        }
    }
    
    func unfocus() {
        self.removeAllActions()
        let resetPosition = SKAction.move(to: GameScene.current.frame.mid(), duration: 0.5)
        resetPosition.timingMode = .easeOut
        self.run(resetPosition)
        let zoom = SKAction.scale(to: 1, duration: 0.5)
        zoom.timingMode = .easeOut
        self.run(zoom)
    }
    
    func toggleCatFocusInfo() {
        func hide() {
            let pushOut = SKAction.group([SKAction.moveTo(y: camFrame.midY+5, duration: 0.35),
                                          SKAction.fadeOut(withDuration: 0.35)])
            pushOut.timingMode = .easeIn
            for child in self.catInfo.children {
                child.run(pushOut, completion: {
                    child.removeFromParent()
                })
            }
        }
        
        func display() {
            let quickinfobg = SKPixelSpriteNode(pixelImageNamed: "catfocus_quickinfobg")
            quickinfobg.alpha = 0
            if let catColor = currentFocus?.sprite.colors.primaryColor {
                quickinfobg.color = catColor
            } else {
                quickinfobg.color = SKColor.gray()
            }
            
            quickinfobg.colorBlendFactor = 1
            quickinfobg.setScale(topBar.xScale)
            quickinfobg.position.y = camFrame.midY-(quickinfobg.frame.height*5)
            quickinfobg.zPosition = 50
            let moveIn = SKAction.moveTo(y: camFrame.midY-(quickinfobg.frame.height*1.5), duration: 0.35)
            moveIn.timingMode = .easeOut
            let pushIn = SKAction.group([moveIn, SKAction.fadeIn(withDuration: 0.35)])
            quickinfobg.run(pushIn, completion: {
                
            })
    
            let catName = SKLabelNode(fontNamed: "Silkscreen")
            catName.zPosition = 2
            catName.text = currentFocus?.firstname
            catName.setScale(1/10)
            catName.fontSize = 81
            catName.fontColor = SKColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            catName.verticalAlignmentMode = .center
            catName.position.y = 5
//            catName.position.y = 
            quickinfobg.addChild(catName)
            
            /* TODO: Add this to a skpixellabel class and use it in the score as well */
            
            for heartIndex in -2...2 {
                let heart = SKPixelSpriteNode(pixelImageNamed: "heart")
                heart.zPosition = 1
                heart.position.y = -5
                heart.position.x = 8*CGFloat(heartIndex)
                
                quickinfobg.addChild(heart)
            }
            
            self.catInfo.addChild(quickinfobg)
        }
        
        if currentFocus != nil { // DISPLAY
            if self.catInfo.children.isEmpty {
               display()
            } else {
                hide()
                display()
            }
        } else { // HIDE
            hide()
        }
    }
    
    func displayCatSelection() {
        if menu.isOpen == true {
            menuButton.enabled = false // FIXME: this needs to actually do shit
            menu.close()
        }
        unfocus()
        
        var isShiftingCats = false
        var catSpriteArray: [SKPixelSpriteNode] = []
        var currentCatSprite: SKPixelSpriteNode
        
        let background = SKPixelSpriteNode(pixelImageNamed: "catselect_bg")
        background.setScale(GameScene.current.frame.width/background.frame.width)
        background.zPosition = 1000
        background.alpha = 0
        self.addChild(background)
        
        let cats = PlistManager.sharedInstance.getValueForKey(key: "Selectable Cats") as! NSDictionary
        for cat in cats {
            if let catSkin = cat.value.value(forKey: "skin") as? String {
                catSpriteArray.append(SKPixelSpriteNode(pixelImageNamed: catSkin))
                print(catSkin)
            }
        }
        currentCatSprite = catSpriteArray[0]
        
        let titleBar = SKPixelSpriteNode(pixelImageNamed: "catselect_titlebar")
        background.addChild(titleBar)
        titleBar.zPosition = 10
        titleBar.position = titleBar.convert(CGPoint(x: 0, y:self.frame.maxY), from: self)
        titleBar.position.y -= titleBar.frame.height/2

        let title = SKLabelNode(fontNamed: "Fipps-Regular")
        titleBar.addChild(title)
        title.zPosition = 1
        title.text = "MEOW TOWN"
        title.setScale(1/10)
        title.fontSize = 80
        title.fontColor = SKColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        title.verticalAlignmentMode = .center

        let circleBackground = SKPixelSpriteNode(pixelImageNamed: "catselect_circle")
        background.addChild(circleBackground)
        circleBackground.zPosition = 10
        circleBackground.position.y -= 5
        
        let circleCropNode = SKCropNode()
        background.addChild(circleCropNode)
        circleCropNode.zPosition = 11
        circleCropNode.position = circleBackground.position
        circleCropNode.maskNode = SKPixelSpriteNode(pixelImageNamed: "catselect_circle_mask")
        
        let description = SKLabelNode(fontNamed: "Silkscreen")
        background.addChild(description)
        description.zPosition = 10
        description.text = "Pick A Cat"
        description.setScale(1/10)
        description.fontSize = 80
        description.position.y = circleBackground.frame.maxY+7
        description.fontColor = SKColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        description.verticalAlignmentMode = .center
        
        for cat in catSpriteArray {
            circleCropNode.addChild(cat)
            cat.position = CGPoint(x: (catSpriteArray.index(of: cat)!*55), y: 0)
        }

        func shift(left l: Bool) -> SKAction {
            isShiftingCats = true
            var multiplier: CGFloat = 1
            if l {
                multiplier = -1
            }
            //return SKAction.moveBy(x: multiplier*55, y: 0, duration: 0.5) // TODO: Find a springy way of doing this again
            return SKAction.moveByX(deltaX: multiplier*55, y: 0, duration: 0.5, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0)
        }
        
        let leftButton = SKPixelButtonNode(pixelImageNamed: "catselect_arrow")
        let rightButton = SKPixelButtonNode(pixelImageNamed: "catselect_arrow")

        func updateButtons() {
            if catSpriteArray.index(of: currentCatSprite) == 0 {
                leftButton.run(SKAction.fadeAlpha(to: 0.5, duration: 0.5))
                rightButton.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
                leftButton.isUserInteractionEnabled = false
                rightButton.isUserInteractionEnabled = true
            } else if catSpriteArray.index(of: currentCatSprite) == catSpriteArray.count - 1 {
                leftButton.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
                rightButton.run(SKAction.fadeAlpha(to: 0.5, duration: 0.5))
                leftButton.isUserInteractionEnabled = true
                rightButton.isUserInteractionEnabled = false
            } else {
                leftButton.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
                rightButton.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
                leftButton.isUserInteractionEnabled = true
                rightButton.isUserInteractionEnabled = true
            }
        }
        
        background.addChild(leftButton)
        leftButton.zPosition = 12
        leftButton.position.x = circleBackground.frame.minX-6
        leftButton.position.y = circleBackground.position.y
        leftButton.action = {
            if !isShiftingCats && catSpriteArray.index(of: currentCatSprite) > 0  {
                currentCatSprite = catSpriteArray[catSpriteArray.index(of: currentCatSprite)!-1]
                updateButtons()
                for cat in catSpriteArray {
                    cat.run(shift(left: false), completion: {
                        if catSpriteArray.index(of: cat) == catSpriteArray.count-1 {
                            isShiftingCats = false
                        }
                    })
                }
            }
        }

        background.addChild(rightButton)
        rightButton.zPosition = 12
        rightButton.position.x = circleBackground.frame.maxX+6
        rightButton.position.y = circleBackground.position.y
        rightButton.xScale = -1
        rightButton.action = {
            if !isShiftingCats && catSpriteArray.index(of: currentCatSprite) < catSpriteArray.count - 1  {
                currentCatSprite = catSpriteArray[catSpriteArray.index(of: currentCatSprite)!+1]
                updateButtons()
                for cat in catSpriteArray {
                    cat.run(shift(left: true), completion: {
                        if catSpriteArray.index(of: cat) == catSpriteArray.count-1 {
                            isShiftingCats = false
                        }
                    })
                }
            }
        }

        let doneButton = SKPixelButtonNode(pixelImageNamed: "catselect_done", withText: "Mine!")
        background.addChild(doneButton)
        doneButton.zPosition = 12
        doneButton.position.y = circleBackground.frame.minY-11
        doneButton.action = {
            isShiftingCats = true
            GameScene.current.world.addCat(name: currentCatSprite.textureName)
            background.run(SKAction.fadeAlpha(to: 0, duration: 0.5), completion: {
                background.removeAllChildren()
                background.removeFromParent()
            })
        }
        
        background.run(SKAction.fadeAlpha(to: 1, duration: 1))
        
        updateButtons()
    }
    
    func update(currentTime: CFTimeInterval) {
        if currentFocus != nil {
            var point = currentFocus!.sprite.positionInScene
            if currentFocus!.isKitten() {
                point.y += 40
            } else {
                point.y += 70
            }
            let action = SKAction.move(to: point, duration: 0.15)
            self.run(action)
        }
        menu.update(currentTime: currentTime)
        
    }
    
    func updateScore(score: Int) {
        if let scoreLabel = topBar.childNode(withName: "scoreCount") as? SKLabelNode {
            scoreLabel.text = "Calories: \(score)"
        }
        
    }
    
    func alert(type: String, message: String) {
        var bgColor: SKColor
        var alertIcon: SKPixelSpriteNode
        switch type {
        case "error":
            bgColor = SKColor(red: 223/255, green: 51/255, blue: 41/255, alpha: 1)
            alertIcon = SKPixelSpriteNode(pixelImageNamed: "error_icon")
        case "warning":
            bgColor = SKColor(red: 249/255, green: 208/255, blue: 51/255, alpha: 1)
            alertIcon = SKPixelSpriteNode(pixelImageNamed: "warning_icon")
        case "success":
            bgColor = SKColor(red: 0/255, green: 187/255, blue: 125/255, alpha: 1)
            alertIcon = SKPixelSpriteNode(pixelImageNamed: "success_icon")
        default:
            bgColor = SKColor(red: 0/255, green: 187/255, blue: 125/255, alpha: 1)
            alertIcon = SKPixelSpriteNode(pixelImageNamed: "warning_icon") // default to success
        }
        
        let bgCropper = SKCropNode()
        bgCropper.maskNode = SKSpriteNode(color: SKColor.red(), size: CGSize(width: camFrame.width, height: 43))
        bgCropper.zPosition = 300
        bgCropper.position.y = -topBar.currentHeight/2-bgCropper.maskNode!.currentHeight/2
        topBar.addChild(bgCropper)
        
        let bg = SKSpriteNode(color: bgColor, size: CGSize(width: camFrame.width, height: 43))
        bg.zPosition = 0
        bg.position.y = bg.currentHeight
        bgCropper.addChild(bg)
        
        let bgBottom = SKSpriteNode(color: bgColor.darkerColor(percent: 0.2), size: CGSize(width: bg.width, height: 1))
        bgBottom.zPosition = 1
        bgBottom.position.y = -bg.currentHeight/2+0.5
        bg.addChild(bgBottom)
        
        let showAlert = SKAction.moveTo(y: 0, duration: 0.2)//0.2
        showAlert.timingMode = .easeOut
        let hideAlert = SKAction.moveTo(y: bg.currentHeight, duration: 0.2)
        hideAlert.timingMode = .easeIn
        
        bg.run(SKAction.sequence([showAlert, SKAction.wait(forDuration: 2), hideAlert]), completion: {
            bgCropper.removeFromParent()
        })
        
        alertIcon.zPosition = 2
        alertIcon.color = bgColor.lighterColor(percent: 0.25)
        alertIcon.colorBlendFactor = 1
        alertIcon.position.x = -65
        bg.addChild(alertIcon)
        
        
        let messageNode = SKNode()
        let separators = NSCharacterSet.whitespacesAndNewlines()
        let words = message.components(separatedBy: separators)
        
        let width = 25
        
        
        var labels: [SKLabelNode] = [] // each line is a label and cannot exceed the width constant
        var currentLabelIndex = -1 // start at -1 to show we need a first one
        
        func createNewLine() {
            currentLabelIndex += 1
            
            let line = SKLabelNode(fontNamed: "Silkscreen")
            line.zPosition = 10
            line.text = ""
            line.setScale(1/10)
            line.fontSize = 80
            line.fontColor = SKColor.white()
            line.position.y = -(CGFloat(currentLabelIndex)*7)
            line.verticalAlignmentMode = .top
            line.horizontalAlignmentMode = .left
            messageNode.addChild(line)
            
            labels.append(line)
            
        }
        
        for word in words {
            if currentLabelIndex == -1 { // if first label needs to be created
                createNewLine()
            }
            
            let thisWordLength = word.characters.count
            let currentLabelTextLength = labels[currentLabelIndex].text!.characters.count
            
            
            if (currentLabelTextLength + thisWordLength + 1) > width { // Create New Line (+1 for space)
                createNewLine()
            }
            
            labels[currentLabelIndex].text!.append(word+" ")
        }
        
       
        
        messageNode.position.x = -messageNode.calculateAccumulatedFrame().width/2+alertIcon.currentWidth-10
        messageNode.position.y = messageNode.calculateAccumulatedFrame().height/2
        
        bg.addChild(messageNode)
    }
}




