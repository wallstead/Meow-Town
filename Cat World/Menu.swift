//
//  Menu.swift
//  Meow Town
//
//  Created by Willis Allstead on 6/10/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class Menu: SKNode {
    var isOpen: Bool!
    var menuIsAnimating: Bool!
    var panelDepth: Int = 0
    var camFrame: CGRect!
    var topBar: SKPixelSpriteNode!
    var menuCropper: SKCropNode!
    var bgpanel: SKPixelSpriteNode!
    var settingsButton: SKPixelToggleButtonNode!
    var infoButton: SKPixelToggleButtonNode!
    var IAPButton: SKPixelToggleButtonNode!
    var topbuttonPanelBG: SKPixelSpriteNode!
    var storeContainer: SKSpriteNode!
    
    // MARK: Initialization
    
    convenience init(camFrame: CGRect, topBar: SKPixelSpriteNode) {
        self.init()
        self.camFrame = camFrame
        self.topBar = topBar
        self.isOpen = false
        self.menuIsAnimating = false
        
        DispatchQueue.main.async {
            self.layout()
        }
    }
    
    func layout() {
        bgpanel = SKPixelSpriteNode(pixelImageNamed: "topbar_menupanel")
        bgpanel.color = SKColor(red: 212/255, green: 29/255, blue: 32/255, alpha: 1)
        bgpanel.colorBlendFactor = 1
        bgpanel.zPosition = 1
        bgpanel.setScale(camFrame.width/bgpanel.frame.width)
        bgpanel.position.y = camFrame.maxY+bgpanel.frame.height/2-topBar.frame.height/2
        self.addChild(bgpanel)
        
        menuCropper = SKCropNode()
        menuCropper.maskNode = SKPixelSpriteNode(pixelImageNamed: "topbar_menupanel")
        menuCropper.zPosition = 1
        menuCropper.isUserInteractionEnabled = false
        bgpanel.addChild(menuCropper)
        
        settingsButton = SKPixelToggleButtonNode(pixelImageNamed: "topbar_menupanel_settingsbutton")
        settingsButton.zPosition = 25
        settingsButton.position.x = -bgpanel.currentWidth/2+settingsButton.frame.width/2
        settingsButton.position.y = bgpanel.currentHeight/2-settingsButton.frame.height/2
        settingsButton.action = {
            self.toggleTopButton(toToggle: self.settingsButton)
        }
        menuCropper.addChild(settingsButton)
        
        infoButton = SKPixelToggleButtonNode(pixelImageNamed: "topbar_menupanel_infobutton")
        infoButton.zPosition = 25
        infoButton.position.x = 0
        infoButton.position.y = bgpanel.currentHeight/2-infoButton.frame.height/2
        infoButton.action = {
            self.toggleTopButton(toToggle: self.infoButton)
        }
        menuCropper.addChild(infoButton)
        
        IAPButton = SKPixelToggleButtonNode(pixelImageNamed: "topbar_menupanel_iapbutton")
        IAPButton.zPosition = 25
        IAPButton.position.x = bgpanel.currentWidth/2-IAPButton.frame.width/2
        IAPButton.position.y = bgpanel.currentHeight/2-IAPButton.frame.height/2
        IAPButton.action = {
            self.toggleTopButton(toToggle: self.IAPButton)
        }
        menuCropper.addChild(IAPButton)
        
        topbuttonPanelBG = SKPixelSpriteNode(pixelImageNamed: "topbar_menupanel")
        topbuttonPanelBG.color = SKColor(red: 0/255, green: 187/255, blue: 125/255, alpha: 1)
        topbuttonPanelBG.colorBlendFactor = 1
        topbuttonPanelBG.zPosition = 20
        topbuttonPanelBG.position.y = bgpanel.currentHeight-infoButton.frame.height
        menuCropper.addChild(topbuttonPanelBG)
        
        storeContainer = SKSpriteNode(color: SKColor.clear, size: CGSize(width: bgpanel.currentWidth, height: bgpanel.currentHeight-settingsButton.frame.height))
        storeContainer.zPosition = 1
        storeContainer.isUserInteractionEnabled = false
        storeContainer.position.y = -infoButton.frame.height/2
        menuCropper.addChild(storeContainer)
        
//        collectionBG = SKSpriteNode()
//        collectionBG.color = SKColor(colorLiteralRed: 182/255, green: 24/255, blue: 25/255, alpha: 1)
//        collectionBG.zPosition = 2
//        collectionBG.anchorPoint = CGPoint(x: 0.5, y: 1)
//        collectionBG.position.y = storeContainer.currentHeight/2 - 20
//
//        storeContainer.addChild(collectionBG)
        
        let title = SKLabelNode(fontNamed: "Fipps-Regular")
        title.zPosition = 51
        title.text = "store"
        title.setScale(1/10)
        title.fontSize = 80
        title.fontColor = SKColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        title.verticalAlignmentMode = .center
        title.position.y = storeContainer.currentHeight/2 - 10
        storeContainer.addChild(title)
        
        let titleBG = SKSpriteNode(color: SKColor(red: 212/255, green: 29/255, blue: 32/255, alpha: 1), size: CGSize(width: bgpanel.currentWidth, height: 20))
        titleBG.zPosition = 50
        titleBG.position.y = title.position.y
        storeContainer.addChild(titleBG)
        
        let collectionBase = SKSpriteNode()
        collectionBase.size = titleBG.size
        collectionBase.zPosition = 10
        collectionBase.position.y = titleBG.position.y
        storeContainer.addChild(collectionBase)
        
        Store()
        
//        displayCollection(parent: collectionBase)
    }
    
    func toggleTopButton(toToggle: SKPixelToggleButtonNode) {
        let topButtons = [settingsButton, infoButton, IAPButton]
        for button in topButtons {
            if button?.enabled == true && button != toToggle {
                button?.enabled = false
            }
        }
        if toToggle.enabled == true { // enabling currently
            openTopButtonBackground()
            displayContentForTopButton(button: toToggle)
        } else { // disabling currently
            closeTopButtonBackground()
        }
    }
    
    func openTopButtonBackground() {
        topbuttonPanelBG.removeAllActions()
        storeContainer.removeAllActions()
        if topbuttonPanelBG.position.y != 0 {
            let displayPanel = SKAction.moveTo(y: 0, duration: 0.3)
            topbuttonPanelBG.run(displayPanel)
            let displayContainer = SKAction.moveTo(y: -bgpanel.currentHeight+infoButton.currentHeight/2, duration: 0.3)
            storeContainer.run(displayContainer)
        }
    }
    
    func closeTopButtonBackground() {
        topbuttonPanelBG.removeAllActions()
        storeContainer.removeAllActions()
        if topbuttonPanelBG.position.y != bgpanel.currentHeight-infoButton.frame.height {
            let hidePanel = SKAction.moveTo(y: bgpanel.currentHeight-infoButton.frame.height, duration: 0.3)
            topbuttonPanelBG.run(hidePanel)
            let hideContainer = SKAction.moveTo(y: -infoButton.frame.height/2, duration: 0.3)
            storeContainer.run(hideContainer)
        }
    }
    
    func displayContentForTopButton(button: SKPixelToggleButtonNode) {
        let contentDisplayed: String?
        switch button.textureName {
            case "topbar_menupanel_settingsbutton":
                contentDisplayed = "settings"
            case "topbar_menupanel_infobutton":
                contentDisplayed = "info"
            case "topbar_menupanel_iapbutton":
                contentDisplayed = "iap"
            default:
                contentDisplayed = nil
        }
        
        if topbuttonPanelBG.name != contentDisplayed { // content not already shown
            topbuttonPanelBG.name = contentDisplayed
            /* Remove old content */
            for child in topbuttonPanelBG.children {
                child.removeAllActions()
                child.run(SKAction.fadeAlpha(to: 0, duration: 0.25), completion: {
                    child.removeFromParent()
                })
            }
            
            let content = SKNode()
            content.zPosition = 1
            content.alpha = 0
            content.run(SKAction.fadeAlpha(to: 1, duration: 0.25))
            
            topbuttonPanelBG.addChild(content)
            
            /* Add new content */
            if contentDisplayed == "settings" {
                let addCat = SKPixelButtonNode(pixelImageNamed: "catselect_done", withText: "+CAT")
                addCat.zPosition = 1
                addCat.action = {
                    var possibleCatNames: [String] = []
                    if let availableCats = GameScene.current.defaultCats?["Available Cats"].array {
                        for cat in availableCats {
                            if let catSkin = cat as? String {
                                possibleCatNames.append(catSkin)
                            }
                        }
                    }

                    let randIndex = Int(arc4random_uniform(UInt32(possibleCatNames.count)))
                    GameScene.current.world!.addCat(name: possibleCatNames[randIndex])
                }
                content.addChild(addCat)
                
                let togglePhysics = SKPixelButtonNode(pixelImageNamed: "catselect_done", withText: "phys")
                togglePhysics.zPosition = 1
                togglePhysics.position.y = addCat.position.y - 15
                togglePhysics.action = {
                    GameScene.current.view?.showsPhysics.toggle()
                }
                content.addChild(togglePhysics)
                
                let toggleNodeCount = SKPixelButtonNode(pixelImageNamed: "catselect_done", withText: "nodes")
                toggleNodeCount.zPosition = 1
                toggleNodeCount.position.y = addCat.position.y - 30
                toggleNodeCount.action = {
                    GameScene.current.view?.showsNodeCount.toggle()
                }
                content.addChild(toggleNodeCount)
                
                let toggleFPS = SKPixelButtonNode(pixelImageNamed: "catselect_done", withText: "fps")
                toggleFPS.zPosition = 1
                toggleFPS.position.y = addCat.position.y - 45
                toggleFPS.action = {
                    GameScene.current.view?.showsFPS.toggle()
                }
                content.addChild(toggleFPS)
                
                let killCats = SKPixelButtonNode(pixelImageNamed: "catselect_done", withText: "killall")
                killCats.zPosition = 1
                killCats.position.y = addCat.position.y - 60
                killCats.action = {
                    for cat in GameScene.current.world!.cats {
                        cat.die()
                    }
                }
                content.addChild(killCats)

                
            } else if contentDisplayed == "info" {
                let title = SKLabelNode(fontNamed: "Fipps-Regular")
                title.zPosition = 1
                title.text = "Meow Town"
                title.setScale(2/10)
                title.fontSize = 80
                title.fontColor = SKColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                title.verticalAlignmentMode = .center
                title.position.y = topbuttonPanelBG.currentHeight/2 - infoButton.currentHeight - 20
                
                let version = SKLabelNode(fontNamed: "Silkscreen")
                version.zPosition = 1
                version.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
                version.setScale(1/10)
                version.fontSize = 80
                version.fontColor = SKColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                version.verticalAlignmentMode = .center
                version.position.y = topbuttonPanelBG.currentHeight/2 - infoButton.currentHeight - title.frame.height - 15
                
                content.addChild(title)
                content.addChild(version)
            } else {
                let removeAds = SKLabelNode(fontNamed: "Silkscreen")
                removeAds.zPosition = 1
                removeAds.text = "Coming Soon"
                removeAds.setScale(1/10)
                removeAds.fontSize = 80
                removeAds.fontColor = SKColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                removeAds.verticalAlignmentMode = .center
                
                content.addChild(removeAds)
            }
        }
    }
    
    func isAnimating() -> Bool {
        return self.hasActions()
    }
//
    func dropPanelToY(y: CGFloat, duration: TimeInterval) -> SKAction {
        let down1 = SKAction.moveTo(y: y, duration: duration/2) // 1/2
        down1.timingMode = .easeIn
        let up1 = SKAction.moveTo(y: y+30, duration: duration/6) // 3/4
        up1.timingMode = .easeOut
        let down2 = SKAction.moveTo(y: y, duration: duration/8) // 7/8
        down2.timingMode = .easeIn
        
        return SKAction.sequence([down1, up1, down2])
    }

    func displayCollection(parent: SKSpriteNode, withData data: NSDictionary? = nil) {
//
//        let shiftTime = 0.3
//        let timeMode: SKActionTimingMode = .easeOut
//        var type: String
//        self.menuIsAnimating = true
//        
//        /* Figure out what data needs to be displayed */
//        let collectionData: NSDictionary
//        if data != nil {
//            collectionData = data!
//            if collectionData.count != 0 {
//                if collectionData.value(forKey: "id") == nil {
//                    type = "collection"
//                } else {
//                    type = "item"
//                }
//            } else {
//                type = "unknown"
//            }
//        } else {
//            collectionData = GameScene.current.defaultData!["Store"].dict!
//            type = "collection"
//        }
////        print(collectionData)
//        
//        if panelDepth > 1 {
//            let move = SKAction.moveTo(y: 15, duration: shiftTime/2)
//            move.timingMode = timeMode
//            parent.parent?.parent?.parent?.run(move)
//        }
//
//        let collectionBG = SKSpriteNode()
//        
//        collectionBG.size = CGSize(width: storeContainer.frame.width, height: bgpanel.currentHeight-infoButton.currentHeight-20)
//        collectionBG.color = SKColor(colorLiteralRed: 182/255, green: 24/255, blue: 25/255, alpha: 1).darkerColor(percent: 0.125*Double(panelDepth))
//        collectionBG.name = "collectionBG"
//        if data == nil {
//            collectionBG.zPosition = -7
//        } else {
//            collectionBG.zPosition = -7
//        }
//        collectionBG.anchorPoint = CGPoint(x: 0.5, y: 1)
//        collectionBG.position.y = collectionBG.size.height-parent.currentHeight/2
//        parent.addChild(collectionBG)
//        collectionBG.isUserInteractionEnabled = false
//        
//        let showCollection = SKAction.moveTo(y: -parent.currentHeight/2, duration: shiftTime)
//        showCollection.timingMode = timeMode
//        collectionBG.run(showCollection, completion: {
//            self.menuIsAnimating = false
//            parent.isUserInteractionEnabled = true
//        })
//        
//        /* Add buttons */
//        
//        if type == "collection" {
//            var yPosCounter: CGFloat = 0
//            let collection = SKNode()
//            collection.name = "collection"
//            collection.isUserInteractionEnabled = false
//            var itemButtons: [SKPixelCollectionToggleButtonNode] = []
//            let disableButtons = SKAction.run({
//                for itemButton in itemButtons {
//                    itemButton.isUserInteractionEnabled = false
//                }
//            })
//            let enableButtons = SKAction.run({
//                for itemButton in itemButtons {
//                    itemButton.isUserInteractionEnabled = true
//                }
//            })
//            for item in collectionData {
//                var itemImageName = (item.value as! NSDictionary).value(forKey: "image name") as? String
//                let itemButton: SKPixelCollectionToggleButtonNode
//                if itemImageName != nil {
//                    itemButton = SKPixelCollectionToggleButtonNode(type: "collection", iconNamed: itemImageName!, withText: item.key as? String)
//                }else {
//                    itemButton = SKPixelCollectionToggleButtonNode(type: "collection", iconNamed: "burger", withText: item.key as? String)
//                }
//                itemButton.name = "itemButton"
//                itemButtons.append(itemButton)
//                itemButton.zPosition = 1
//                itemButton.position.y = (-35*yPosCounter)-5-itemButton.currentHeight/2
//                itemButton.isUserInteractionEnabled = false
//                itemButton.run(SKAction.wait(forDuration: shiftTime), completion: {
//                    itemButton.isUserInteractionEnabled = true
//                })
//                collection.addChild(itemButton)
//
//                yPosCounter += 1
//                
//                var itemSubDict = NSDictionary()
//                
//                var itemButtonsBelow: [SKPixelCollectionToggleButtonNode] = [] // All buttons below the selected one
//                itemButton.onPress = {
//                    itemSubDict = collectionData[item.key as! String] as! NSDictionary
//                    if self.isOpen == true {
//                        itemButton.run(disableButtons)
//                        parent.isUserInteractionEnabled = false
//                        if itemButton.enabled == true {
//                            if let childCollectionBG = itemButton.childNode(withName: "collectionBG") as? SKSpriteNode {
//                                if let childCollection = childCollectionBG.childNode(withName: "collection") {
//                                    for childItemButton in childCollection.children {
//                                        childItemButton.isUserInteractionEnabled = false
//                                        
//                                    }
//                                }
//                            }
//                        }
//                    } else {
//                        itemButton.reset()
//                    }
//                }
//                itemButton.onCancel = { // when the touch moved out of the button
//                    itemButton.run(enableButtons)
//                    parent.isUserInteractionEnabled = true
//                    if itemButton.enabled == true {
//                        if let childCollectionBG = itemButton.childNode(withName: "collectionBG") as? SKSpriteNode {
//                            if let childCollection = childCollectionBG.childNode(withName: "collection") {
//                                for childItemButton in childCollection.children {
//                                    childItemButton.isUserInteractionEnabled = true
//                                }
//                            }
//                        }
//                    }
//                }
//                itemButton.action = {
//                    
//                    
//                    if self.menuIsAnimating == false && self.isOpen == true {
//                        if parent.name == "itemButton" {
//                            if let parentItemButton = parent as? SKPixelCollectionToggleButtonNode {
//                                if parentItemButton.enabled == true && parentItemButton.texture == parentItemButton.pressedTexture {
//                                    parentItemButton.reset()
//                                }
//                            }
//                        }
//                        
//                        itemButton.isUserInteractionEnabled = false
//                        self.menuIsAnimating = true
//                        if itemButton.enabled == false || itemButton.enabled == nil { // CLOSE
//                        
//                            if let childCollectionBG = itemButton.childNode(withName: "collectionBG") as? SKSpriteNode {
//                                var belowCounter: CGFloat = 1
//                                collectionBG.run(SKAction.sequence([disableButtons, showCollection, enableButtons]))
//                                
//                                func moveButtonsBack() {
//                                    var yPosCounterReplace: CGFloat = 0
//                                    for button in itemButtons {
//                                        let move = SKAction.moveTo(y: (-35*yPosCounterReplace)-5-itemButton.currentHeight/2, duration: shiftTime/2)
//                                        move.timingMode = timeMode
//                                        button.run(move, completion: {
//                                            if button == itemButtons.last {
//                                                yPosCounter = 0
//                                                belowCounter = 0
//                                                itemButton.zPosition = 1
//                                                self.panelDepth -= 1
//                                                itemButtonsBelow.removeAll()
//                                                
//                                                for itemButton in itemButtons {
//                                                    itemButton.isUserInteractionEnabled = true
//                                                }
//                                                self.menuIsAnimating = false
//                                                parent.isUserInteractionEnabled = true
//                                            }
//                                        })
//                                        yPosCounterReplace += 1
//                                    }
//                                }
//                                if self.panelDepth > 1 {
//                                    let move = SKAction.moveTo(y: -15, duration: shiftTime/2)
//                                    move.timingMode = timeMode
//                                    parent.run(move)
//                                }
//                                if itemButtonsBelow.isEmpty == false {
//                                    for itemButtonBelow in itemButtonsBelow {
//                                        let move = SKAction.moveTo(y: (-35*belowCounter)-itemButton.currentHeight/2, duration: shiftTime)
//                                        move.timingMode = timeMode
//                                        itemButtonBelow.run(move)
//                                        belowCounter += 1
//                                    }
//                                }
//                                
//                                let moveChildCollection = SKAction.moveTo(y: childCollectionBG.size.height-childCollectionBG.parent!.frame.height/2, duration: shiftTime)
//                                moveChildCollection.timingMode = timeMode
//                                childCollectionBG.run(moveChildCollection, completion: {
//                                    childCollectionBG.removeFromParent()
//                                    moveButtonsBack()
//                                })
//                            } else {
//                                self.menuIsAnimating = false
//                            }
//                        } else { // OPEN
//                            /* Move all buttons up, centering the selected button at the top */
//                            
//                            for button in itemButtons {
//                                /* calculate difference in index */
//                                let thisIndex = itemButtons.index(of: button)
//                                let baseIndex = itemButtons.index(of: itemButton)
//                                let offset = -1*(baseIndex!-thisIndex!)
//                                
//                                
//                                let move = SKAction.moveTo(y: -button.currentHeight/2-(35*CGFloat(offset)), duration: shiftTime/2)
//                                move.timingMode = timeMode
//                                button.run(move, completion: {
//                                    if offset == 0 {
//                                        self.panelDepth += 1
//                                        self.displayCollection(parent: itemButton, withData: itemSubDict)
//                                        var belowCounter: CGFloat = 0
//                                        for itemButtonBelow in itemButtonsBelow {
//                                            let move = SKAction.moveTo(y: -collectionBG.currentHeight-(35*belowCounter)-5-itemButton.currentHeight/2, duration: shiftTime)
//                                            move.timingMode = timeMode
//                                            itemButtonBelow.run(move)
//                                            belowCounter += 1
//                                        }
//                                        itemButton.zPosition = 9
//                                        self.menuIsAnimating = false
//                                        
//                                    }
//                                })
//                                if offset != 0 && button.enabled == true  { // Make sure only the selected button is enabled
//                                    button.enabled = false
//                                }
//                                if offset > 0 {
//                                    itemButtonsBelow.append(button)
//                                }
//                            }
//                        }
//                    } else {
//                        itemButton.enabled = false
//                    }
//                }
//            }
//            collectionBG.addChild(collection)
//        } else if type == "item" {
//            
//            let itemImageContainter = SKPixelSpriteNode(pixelImageNamed: "topbar_menupanel_itemimagecontainer")
//            itemImageContainter.color = collectionBG.color.darkerColor(percent: 0.1)
//            itemImageContainter.colorBlendFactor = 1
//            itemImageContainter.zPosition = 1
//            itemImageContainter.position.y = -36
//            collectionBG.addChild(itemImageContainter)
//            
//            let itemImage = SKPixelSpriteNode(pixelImageNamed: collectionData.value(forKey: "image name") as! String)
//            itemImage.zPosition = 1
//            itemImage.position.y = 6
//            itemImage.setScale(2)
//            itemImageContainter.addChild(itemImage)
//
//            let itemDescription = SKLabelNode(fontNamed: "Silkscreen")
//            itemDescription.zPosition = 2
//            itemDescription.text = collectionData.value(forKey: "description") as? String
//            itemDescription.setScale(1/10)
//            itemDescription.fontSize = 80
//            itemDescription.fontColor = SKColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
//            itemDescription.verticalAlignmentMode = .center
//            itemDescription.position.y = itemImageContainter.frame.minY+10
//            collectionBG.addChild(itemDescription)
//            
//            let infoTable = SKNode()
//            let infoDict = collectionData.value(forKey: "info") as! NSDictionary
//            let itemCost = infoDict.value(forKey: "price") as! Int
//            var infoCounter = 0
//            for infoItem in infoDict {
//                // create left side and right side bg
//                let leftSide = SKSpriteNode(color: collectionBG.color.darkerColor(percent: 0.1), size: CGSize(width: itemImageContainter.frame.width/2, height: 15))
//                leftSide.position.x = -leftSide.frame.width/2
//                leftSide.position.y = -(CGFloat(infoCounter)*16)
//                infoTable.addChild(leftSide)
//                
//                let leftInfoText = SKLabelNode(fontNamed: "Silkscreen")
//                leftInfoText.zPosition = 2
//                leftInfoText.text = infoItem.key as? String
//                leftInfoText.setScale(1/10)
//                leftInfoText.fontSize = 80
//                leftInfoText.fontColor = SKColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
//                leftInfoText.verticalAlignmentMode = .center
//                leftInfoText.horizontalAlignmentMode = .right
//                leftInfoText.position.x = leftSide.frame.width/2-6
//                
//                leftSide.addChild(leftInfoText)
//                
//                let rightSide = SKSpriteNode(color: collectionBG.color.darkerColor(percent: 0.2), size: CGSize(width: itemImageContainter.frame.width/2, height: 15))
//                rightSide.position.x = rightSide.frame.width/2
//                rightSide.position.y = -(CGFloat(infoCounter)*16)
//                infoTable.addChild(rightSide)
//                
//                let rightInfoText = SKLabelNode(fontNamed: "Silkscreen")
//                rightInfoText.zPosition = 2
//                rightInfoText.text = "\(infoItem.value)"
//                rightInfoText.setScale(1/10)
//                rightInfoText.fontSize = 80
//                rightInfoText.fontColor = SKColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
//                rightInfoText.verticalAlignmentMode = .center
//                rightInfoText.horizontalAlignmentMode = .left
//                rightInfoText.position.x = -rightSide.frame.width/2+6
//                
//                rightSide.addChild(rightInfoText)
//                
//                infoCounter += 1
//            }
//            collectionBG.addChild(infoTable)
//            infoTable.position.y = itemImageContainter.frame.minY-8.5
//            
//            let enableButton = SKPixelToggleSliderNode(withState: collectionData.value(forKey: "enabled") as! Bool)
//            enableButton.color = collectionBG.color.darkerColor(percent: 0.1)
//            enableButton.colorBlendFactor = 1
//            enableButton.zPosition = 2
//            enableButton.position.y = infoTable.position.y - 49.2 //infoTable.position.y - 49.35 - 18
//            enableButton.onStateChange = {
////                GameScene.current.catCam.alert(type: "warning", message: "The enabled property of this button is now set to \(enableButton.enabled!).")
//                
//                if enableButton.enabled == true {
//                    let wait = infoDict.value(forKey: "regen") as! Int
//                    if GameScene.current.catCam.itemPanel.addQuickItem(itemName: collectionData.value(forKey: "image name")! as! String, waitTime: wait) == false {
//                        GameScene.current.catCam.alert(type: "error", message: "Cannot enable an item already enabled.")
//                    } else {
////                        if GameScene.current.toggleEnable(withData: data!) == true {
////                            GameScene.current.catCam.alert(type: "success", message: "Toggled.")
////                        }
//                    }
//                } else {
//                    if GameScene.current.catCam.itemPanel.removeQuickItem(itemName: collectionData.value(forKey: "image name")! as! String) == false {
//                        GameScene.current.catCam.alert(type: "error", message: "Cannot remove an item that doesn't exist.")
//                    } else {
////                        if GameScene.current.toggleEnable(withData: data!) == true {
////                            GameScene.current.catCam.alert(type: "success", message: "Toggled.")
////                        }
//                    }
//                }
//               
//            }
//            
//            let buyButton = SKPixelButtonNode(pixelImageNamed: "basicbutton", withText: "Buy")
//            buyButton.color = SKColor(colorLiteralRed: 255/255, green: 162/255, blue: 51/255, alpha: 1)
//            buyButton.colorBlendFactor = 1
//            buyButton.zPosition = 2
//            buyButton.position.y = infoTable.position.y - 49.2
//            buyButton.action = {
////                if GameScene.current.world.score >= itemCost {
////                    if GameScene.current.attemptPurchase(withData: data!) == true {
////                        GameScene.current.catCam.alert(type: "success", message: "You successfully bought \(collectionData.value(forKey: "name")!)s.")
////                        /* TODO: Hide buyButton */
////                        buyButton.removeFromParent()
////                        collectionBG.addChild(enableButton)
////                    } else {
////                        GameScene.current.catCam.alert(type: "error", message: "An error occured when attempting to purchase \(collectionData.value(forKey: "name")!)s.")
////                    }
////                } else {
////                    GameScene.current.catCam.alert(type: "error", message: "You don't have enough calories to buy \(collectionData.value(forKey: "name")!)s.")
////                }
//            }
//            
//            if collectionData.value(forKey: "owned") as! Bool == true {
//                collectionBG.addChild(enableButton)
//            } else {
//                collectionBG.addChild(buyButton)
//            }
//            
//        }
    }
    
    func toggle() {
        removeAllActions()
        if isOpen! {
            close()
        } else {
            if GameScene.current.catCam.itemPanel.isOpen == true {
                GameScene.current.catCam.itemPanel.close()
                GameScene.current.catCam.itemsButton.enabled = false
            }
            open()
        }
    }
    
    func open() {
        self.zPosition = 200
        self.isOpen = true
        bgpanel.run(dropPanelToY(y: camFrame.minY+bgpanel.frame.height/2, duration: 0.75))
    }
    
    func close() {
        self.zPosition = 100
        self.isOpen = false
        bgpanel.run(dropPanelToY(y: camFrame.maxY-self.topBar.frame.height+bgpanel.frame.height/2, duration: 0.75))
        
        /* TODO: Make it only close when it is actually open */
        closeTopButtonBackground()
        let topButtons = [settingsButton, infoButton, IAPButton]
        for button in topButtons {
            if button?.enabled == true {
                button?.enabled = false
            }
        }
    }
    
    func update(currentTime: CFTimeInterval) {
    }
}


