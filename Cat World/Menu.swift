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
    var panelDepth: Int!
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
        self.panelDepth = 0
        self.camFrame = camFrame
        self.topBar = topBar
        self.isOpen = false
        layout()
    }
    
    func layout() {
        bgpanel = SKPixelSpriteNode(textureName: "topbar_menupanel")
        bgpanel.color = DynamicColor(red: 212/255, green: 29/255, blue: 32/255, alpha: 1)
        bgpanel.colorBlendFactor = 1
        bgpanel.zPosition = 0
        bgpanel.setScale(camFrame.width/bgpanel.width)
        bgpanel.position.y = camFrame.maxY+bgpanel.height/2-topBar.height/2
        self.addChild(bgpanel)
        
        menuCropper = SKCropNode()
        menuCropper.maskNode = SKPixelSpriteNode(textureName: "topbar_menupanel")
        menuCropper.zPosition = 1
        menuCropper.userInteractionEnabled = false
        bgpanel.addChild(menuCropper)
        
        settingsButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_settingsbutton")
        settingsButton.zPosition = 10
        settingsButton.position.x = -bgpanel.currentWidth/2+settingsButton.width/2
        settingsButton.position.y = bgpanel.currentHeight/2-settingsButton.height/2
        settingsButton.action = {
            self.toggleTopButton(self.settingsButton)
        }
        menuCropper.addChild(settingsButton)
        
        infoButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_infobutton")
        infoButton.zPosition = 10
        infoButton.position.x = 0
        infoButton.position.y = bgpanel.currentHeight/2-infoButton.height/2
        infoButton.action = {
            self.toggleTopButton(self.infoButton)
        }
        menuCropper.addChild(infoButton)
        
        IAPButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_iapbutton")
        IAPButton.zPosition = 10
        IAPButton.position.x = bgpanel.currentWidth/2-IAPButton.width/2
        IAPButton.position.y = bgpanel.currentHeight/2-IAPButton.height/2
        IAPButton.action = {
            self.toggleTopButton(self.IAPButton)
        }
        menuCropper.addChild(IAPButton)
        
        topbuttonPanelBG = SKPixelSpriteNode(textureName: "topbar_menupanel")
        topbuttonPanelBG.color = DynamicColor(red: 0/255, green: 187/255, blue: 125/255, alpha: 1)
        topbuttonPanelBG.colorBlendFactor = 1
        topbuttonPanelBG.zPosition = 1
        topbuttonPanelBG.position.y = bgpanel.currentHeight-infoButton.height
        menuCropper.addChild(topbuttonPanelBG)
        
        storeContainer = SKSpriteNode(color: SKColor.clearColor(), size: CGSize(width: bgpanel.currentWidth, height: bgpanel.currentHeight-settingsButton.height))
        storeContainer.zPosition = 1
        storeContainer.userInteractionEnabled = false
        storeContainer.position.y = -infoButton.height/2
        menuCropper.addChild(storeContainer)
        
        let title = SKLabelNode(fontNamed: "Silkscreen")
        title.zPosition = 1
        title.text = "-STORE-"
        title.setScale(2/10)
        title.fontSize = 80
        title.fontColor = DynamicColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        title.verticalAlignmentMode = .Center
        title.position.y = storeContainer.currentHeight/2 - 10
        storeContainer.addChild(title)
        
        displayCollection()
    }
    
    func toggleTopButton(toToggle: SKPixelToggleButtonNode) {
        let topButtons = [settingsButton, infoButton, IAPButton]
        for button in topButtons {
            if button.enabled && button != toToggle {
                button.disable()
            }
        }
        if toToggle.enabled == false { // enabling currently
            openTopButtonBackground()
            displayContentForTopButton(toToggle)
        } else { // disabling currently
            closeTopButtonBackground()
        }
    }
    
    func openTopButtonBackground() {
        topbuttonPanelBG.removeAllActions()
        storeContainer.removeAllActions()
        if topbuttonPanelBG.position.y != 0 {
            let displayPanel = SKAction.moveToY(0, duration: 0.3)
            topbuttonPanelBG.runAction(displayPanel)
            let displayContainer = SKAction.moveToY(-bgpanel.currentHeight+infoButton.currentHeight/2, duration: 0.3)
            storeContainer.runAction(displayContainer)
        }
    }
    
    func closeTopButtonBackground() {
        topbuttonPanelBG.removeAllActions()
        storeContainer.removeAllActions()
        if topbuttonPanelBG.position.y != bgpanel.currentHeight-infoButton.height {
            let hidePanel = SKAction.moveToY(bgpanel.currentHeight-infoButton.height, duration: 0.3)
            topbuttonPanelBG.runAction(hidePanel)
            let hideContainer = SKAction.moveToY(-infoButton.height/2, duration: 0.3)
            storeContainer.runAction(hideContainer)
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
                child.runAction(SKAction.fadeAlphaTo(0, duration: 0.25), completion: {
                    child.removeFromParent()
                })
            }
            
            let content = SKNode()
            content.zPosition = 1
            content.alpha = 0
            content.runAction(SKAction.fadeAlphaTo(1, duration: 0.25))
            
            topbuttonPanelBG.addChild(content)
            
            /* Add new content */
            if contentDisplayed == "settings" {
                let addCat = SKPixelButtonNode(textureName: "catselect_done", text: "+CAT")
                addCat.zPosition = 1
                addCat.action = {
                    GameScene.current.world.addCat("oscar")
                }
                content.addChild(addCat)
            } else if contentDisplayed == "info" {
                let title = SKLabelNode(fontNamed: "Fipps-Regular")
                title.zPosition = 1
                title.text = "FAT FELINE"
                title.setScale(2/10)
                title.fontSize = 80
                title.fontColor = DynamicColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                title.verticalAlignmentMode = .Center
                title.position.y = topbuttonPanelBG.currentHeight/2 - infoButton.currentHeight - 20
                
                let version = SKLabelNode(fontNamed: "Silkscreen")
                version.zPosition = 1
                version.text = "v2.0"
                version.setScale(1/10)
                version.fontSize = 80
                version.fontColor = DynamicColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                version.verticalAlignmentMode = .Center
                version.position.y = topbuttonPanelBG.currentHeight/2 - infoButton.currentHeight - title.frame.height - 15
                
                content.addChild(title)
                content.addChild(version)
            } else {
                let removeAds = SKLabelNode(fontNamed: "Silkscreen")
                removeAds.zPosition = 1
                removeAds.text = "Coming Soon"
                removeAds.setScale(1/10)
                removeAds.fontSize = 80
                removeAds.fontColor = DynamicColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                removeAds.verticalAlignmentMode = .Center
                
                content.addChild(removeAds)
            }
        }
    }
    
    func isAnimating() -> Bool {
        return self.hasActions()
    }
    
    func dropPanelToY(y: CGFloat, duration: NSTimeInterval) -> SKAction {
        let down1 = SKAction.moveToY(y, duration: duration/2) // 1/2
        down1.timingMode = .EaseIn
        let up1 = SKAction.moveToY(y+30, duration: duration/6) // 3/4
        up1.timingMode = .EaseOut
        let down2 = SKAction.moveToY(y, duration: duration/8) // 7/8
        down2.timingMode = .EaseIn
        
        return SKAction.sequence([down1, up1, down2])
    }
    
    func displayCollection() {
        let storeDict = PlistManager.sharedInstance.getValueForKey("Store") as! NSDictionary
        let categoriesDict = storeDict.valueForKey("Categories") as! NSDictionary

        var yPosCounter: CGFloat = 0
        let categories = SKNode()
        for category in categoriesDict {
            let categoryButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_itemcategory", text: category.key as? String)
            categoryButton.zPosition = 3
            categoryButton.position.y = storeContainer.currentHeight/2 - 40 - 35*yPosCounter
            categories.addChild(categoryButton)
            yPosCounter += 1
        }
        storeContainer.addChild(categories)
        
        let collectionBG = SKSpriteNode()
        collectionBG.color = SKColor(colorLiteralRed: 182/255, green: 24/255, blue: 25/255, alpha: 1)
        collectionBG.size = CGSize(width: storeContainer.width, height: categories.calculateAccumulatedFrame().height+10)
        collectionBG.zPosition = 2
        collectionBG.anchorPoint = CGPoint(x: 0.5, y: 1)
        collectionBG.position.y = storeContainer.currentHeight/2 - 20
        storeContainer.addChild(collectionBG)
    }
    
    func toggle() {
        self.removeAllActions()
        if isOpen! {
            close()
        } else {
            open()
        }
    }
    
    func open() {
        self.isOpen = true
        bgpanel.runAction(dropPanelToY(camFrame.minY+bgpanel.height/2, duration: 0.75))
    }
    
    func close() {
        self.isOpen = false
        bgpanel.runAction(dropPanelToY(camFrame.maxY-self.topBar.frame.height+bgpanel.height/2, duration: 0.75))
        
        /* TODO: Make it only close when it is actually open */
        closeTopButtonBackground()
        let topButtons = [settingsButton, infoButton, IAPButton]
        for button in topButtons {
            if button.enabled == true {
                button.disable()
            }
        }
    }
}
