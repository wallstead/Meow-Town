//
//  Menu.swift
//  Cat World
//
//  Created by Willis Allstead on 6/10/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class Menu: SKNode {
    var isOpen: Bool!
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
    
//    var collectionBG: SKSpriteNode!
//    var currentButtons: [[SKPixelToggleCollectionButtonNode]]! // 2D: rows->each depth of menu | cols-> each button in that depth
    
    // MARK: Initialization
    
    convenience init(camFrame: CGRect, topBar: SKPixelSpriteNode) {
        self.init()
        self.camFrame = camFrame
        self.topBar = topBar
        self.isOpen = false
//        self.currentButtons = []
        
        DispatchQueue.main.async {
            self.layout()
        }
    }
    
    func layout() {
        bgpanel = SKPixelSpriteNode(textureName: "topbar_menupanel")
        bgpanel.background.color = SKColor(red: 212/255, green: 29/255, blue: 32/255, alpha: 1)
        bgpanel.background.colorBlendFactor = 1
        bgpanel.zPosition = 1
        bgpanel.setScale(camFrame.width/bgpanel.frame.width)
        bgpanel.position.y = camFrame.maxY+bgpanel.frame.height/2-topBar.frame.height/2
        self.addChild(bgpanel)
        
        menuCropper = SKCropNode()
        menuCropper.maskNode = SKPixelSpriteNode(textureName: "topbar_menupanel")
        menuCropper.zPosition = 1
        menuCropper.isUserInteractionEnabled = false
        bgpanel.addChild(menuCropper)
        
        settingsButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_settingsbutton")
        settingsButton.zPosition = 15
        settingsButton.position.x = -bgpanel.currentWidth/2+settingsButton.frame.width/2
        settingsButton.position.y = bgpanel.currentHeight/2-settingsButton.frame.height/2
        settingsButton.action = {
            self.toggleTopButton(toToggle: self.settingsButton)
        }
        menuCropper.addChild(settingsButton)
        
        infoButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_infobutton")
        infoButton.zPosition = 15
        infoButton.position.x = 0
        infoButton.position.y = bgpanel.currentHeight/2-infoButton.frame.height/2
        infoButton.action = {
            self.toggleTopButton(toToggle: self.infoButton)
        }
        menuCropper.addChild(infoButton)
        
        IAPButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_iapbutton")
        IAPButton.zPosition = 15
        IAPButton.position.x = bgpanel.currentWidth/2-IAPButton.frame.width/2
        IAPButton.position.y = bgpanel.currentHeight/2-IAPButton.frame.height/2
        IAPButton.action = {
            self.toggleTopButton(toToggle: self.IAPButton)
        }
        menuCropper.addChild(IAPButton)
        
        topbuttonPanelBG = SKPixelSpriteNode(textureName: "topbar_menupanel")
        topbuttonPanelBG.color = SKColor(red: 0/255, green: 187/255, blue: 125/255, alpha: 1)
        topbuttonPanelBG.colorBlendFactor = 1
        topbuttonPanelBG.zPosition = 9
        topbuttonPanelBG.position.y = bgpanel.currentHeight-infoButton.frame.height
        menuCropper.addChild(topbuttonPanelBG)
        
        storeContainer = SKSpriteNode(color: SKColor.clear(), size: CGSize(width: bgpanel.currentWidth, height: bgpanel.currentHeight-settingsButton.frame.height))
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
        
        let title = SKLabelNode(fontNamed: "Silkscreen")
        title.zPosition = 11
        title.text = "-STORE-"
        title.setScale(2/10)
        title.fontSize = 80
        title.fontColor = SKColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        title.verticalAlignmentMode = .center
        title.position.y = storeContainer.currentHeight/2 - 10
        storeContainer.addChild(title)
        
        let titleBG = SKSpriteNode(color: SKColor(red: 212/255, green: 29/255, blue: 32/255, alpha: 1), size: CGSize(width: bgpanel.currentWidth, height: 20))
        titleBG.zPosition = 10
        titleBG.position.y = title.position.y
        storeContainer.addChild(titleBG)
        
        displayCollection(parent: titleBG, heightDiff: 20)
    }
    
    func toggleTopButton(toToggle: SKPixelToggleButtonNode) {
        let topButtons = [settingsButton, infoButton, IAPButton]
        for button in topButtons {
            if button?.enabled == true && button != toToggle {
                button?.disable()
            }
        }
        if toToggle.enabled == false { // enabling currently
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
                let addCat = SKPixelButtonNode(textureName: "catselect_done", text: "+CAT")
                addCat.zPosition = 1
                addCat.action = {
                    GameScene.current.world.addCat(name: "oscar")
                }
                content.addChild(addCat)
            } else if contentDisplayed == "info" {
                let title = SKLabelNode(fontNamed: "Fipps-Regular")
                title.zPosition = 1
                title.text = "FAT FELINE"
                title.setScale(2/10)
                title.fontSize = 80
                title.fontColor = SKColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                title.verticalAlignmentMode = .center
                title.position.y = topbuttonPanelBG.currentHeight/2 - infoButton.currentHeight - 20
                
                let version = SKLabelNode(fontNamed: "Silkscreen")
                version.zPosition = 1
                version.text = "v2.0"
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
    
    func dropPanelToY(y: CGFloat, duration: TimeInterval) -> SKAction {
        let down1 = SKAction.moveTo(y: y, duration: duration/2) // 1/2
        down1.timingMode = .easeIn
        let up1 = SKAction.moveTo(y: y+30, duration: duration/6) // 3/4
        up1.timingMode = .easeOut
        let down2 = SKAction.moveTo(y: y, duration: duration/8) // 7/8
        down2.timingMode = .easeIn
        
        return SKAction.sequence([down1, up1, down2])
    }
    
    func displayCollection(parent: SKSpriteNode, heightDiff: CGFloat, withData data: NSDictionary? = nil) {
        let shiftTime = 0.3
        let timeMode: SKActionTimingMode = .easeOut
        
        /* Figure out what data needs to be displayed */
        let collectionData: NSDictionary
        if data != nil {
            collectionData = data!
        } else {
            let storeDict = PlistManager.sharedInstance.getValueForKey(key: "Store") as! NSDictionary
            collectionData = storeDict.value(forKey: "Categories") as! NSDictionary
        }

        /* Add background */
        let collectionBG = SKSpriteNode()
        collectionBG.size = CGSize(width: storeContainer.frame.width, height: bgpanel.currentHeight-infoButton.currentHeight-heightDiff)
        collectionBG.color = SKColor(colorLiteralRed: 182/255, green: 24/255, blue: 25/255, alpha: 1).darkerColor(percent: 0.125*Double(panelDepth))
        collectionBG.name = "collectionBG"
        if data == nil {
            collectionBG.zPosition = -7
        } else {
            collectionBG.zPosition = -7
        }
        collectionBG.anchorPoint = CGPoint(x: 0.5, y: 1)
        collectionBG.position.y = collectionBG.size.height-parent.currentHeight/2
        parent.addChild(collectionBG)
        
        let showCollection = SKAction.moveTo(y: -parent.currentHeight/2, duration: shiftTime)
        showCollection.timingMode = timeMode
        collectionBG.run(showCollection)
        
        /* Add buttons */
        var yPosCounter: CGFloat = 0
        let collection = SKNode()
        var itemButtons: [SKPixelToggleCollectionButtonNode] = []
        for item in collectionData {
            let itemButton = SKPixelToggleCollectionButtonNode(type: "collection", icon: "nag", text: item.key as! String)
            itemButtons.append(itemButton)
            itemButton.zPosition = 1
            itemButton.position.y = (-35*yPosCounter)-5-itemButton.currentHeight/2
            collection.addChild(itemButton)
            yPosCounter += 1
            var itemButtonsBelow: [SKPixelToggleCollectionButtonNode] = [] // All buttons below the selected one
            itemButton.action = {
                if itemButton.enabled == true { // CLOSE
                    /* close the button's child bg */
                    let childCollectionBG = itemButton.childNode(withName: "collectionBG") as! SKSpriteNode // TODO: make this if-let
                    var belowCounter: CGFloat = 1
                    collectionBG.run(showCollection)
                    
                    func moveButtonsBack() {
                        print("moving buttons back")
                        var yPosCounterReplace: CGFloat = 0
                        for button in itemButtons {
                            print("got here")
                            let move = SKAction.moveTo(y: (-35*yPosCounterReplace)-5-itemButton.currentHeight/2, duration: shiftTime)
                            move.timingMode = timeMode
                            button.run(move, completion: {
                                if button == itemButtons.last {
                                    yPosCounter = 0
                                    belowCounter = 0
                                    itemButton.zPosition = 1
                                    self.panelDepth -= 1
                                    itemButtonsBelow.removeAll()
                                }
                            })
                            
                            yPosCounterReplace += 1
                            
                        }
                    }
                    if itemButtonsBelow.isEmpty == false {
                        print(itemButtonsBelow.count)
                        for itemButtonBelow in itemButtonsBelow {
                            let move = SKAction.moveTo(y: (-35*belowCounter)-itemButton.currentHeight/2, duration: shiftTime)
                            move.timingMode = timeMode
                            itemButtonBelow.run(move)
                            belowCounter += 1
                        }
                    } else {
                        
                    }
                    
                    let moveChildCollection = SKAction.moveTo(y: childCollectionBG.size.height-childCollectionBG.parent!.frame.height/2, duration: shiftTime)
                    moveChildCollection.timingMode = timeMode
                    childCollectionBG.run(moveChildCollection, completion: {
                        childCollectionBG.removeFromParent()
                        moveButtonsBack()
                    })
                } else { // OPEN
                    
                    /* Move all buttons up, centering the selected button at the top */
                    for button in itemButtons {
                        /* calculate difference in index */
                        let thisIndex = itemButtons.index(of: button)
                        let baseIndex = itemButtons.index(of: itemButton)
                        let offset = -1*(baseIndex!-thisIndex!)
                        let move = SKAction.moveTo(y: -button.currentHeight/2-(35*CGFloat(offset)), duration: shiftTime)
                        move.timingMode = timeMode
                        button.run(move, completion: {
                            if offset == 0 {
                                self.panelDepth += 1
                                self.displayCollection(parent: itemButton, heightDiff: 50, withData: collectionData.value(forKey: item.key as! String) as? NSDictionary)
                                var belowCounter: CGFloat = 0
                                for itemButtonBelow in itemButtonsBelow {
                                    let move = SKAction.moveTo(y: -collectionBG.currentHeight-(35*belowCounter)-5-itemButton.currentHeight/2, duration: shiftTime)
                                    move.timingMode = timeMode
                                    itemButtonBelow.run(move)
                                    belowCounter += 1
                                }
                                itemButton.zPosition = 10
                            }
                        })
                        if offset != 0 && button.enabled == true  { // Make sure only the selected button is enabled
                            button.disable(withAction: false)
                        }
                        if offset > 0 {
                            itemButtonsBelow.append(button)
                        }
                    }
 
                }
            }
        }
        collectionBG.addChild(collection)
    }
    
    func toggle() {
        removeAllActions()
        if isOpen! {
            close()
        } else {
            open()
        }
    }
    
    func open() {
        self.isOpen = true
        bgpanel.run(dropPanelToY(y: camFrame.minY+bgpanel.frame.height/2, duration: 0.75))
    }
    
    func close() {
        self.isOpen = false
        bgpanel.run(dropPanelToY(y: camFrame.maxY-self.topBar.frame.height+bgpanel.frame.height/2, duration: 0.75))
        
        /* TODO: Make it only close when it is actually open */
        closeTopButtonBackground()
        let topButtons = [settingsButton, infoButton, IAPButton]
        for button in topButtons {
            if button?.enabled == true {
                button?.disable()
            }
        }
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor { // temp
    static func randomColor() -> UIColor {
        // If you wanted a random alpha, just create another
        // random number for that too.
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
