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
        bgpanel.addChild(menuCropper)
        
        settingsButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_settingsbutton")
        settingsButton.zPosition = 2
        settingsButton.position.x = -bgpanel.currentWidth/2+settingsButton.width/2
        settingsButton.position.y = bgpanel.currentHeight/2-settingsButton.height/2
        settingsButton.action = {
            self.toggleTopButton(self.settingsButton)
        }
        menuCropper.addChild(settingsButton)
        
        infoButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_infobutton")
        infoButton.zPosition = 2
        infoButton.position.x = 0
        infoButton.position.y = bgpanel.currentHeight/2-infoButton.height/2
        infoButton.action = {
            self.toggleTopButton(self.infoButton)
        }
        menuCropper.addChild(infoButton)
        
        IAPButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_iapbutton")
        IAPButton.zPosition = 2
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
        
        storeContainer = SKSpriteNode(color: SKColor.orangeColor(), size: CGSize(width: bgpanel.currentWidth, height: bgpanel.currentHeight-settingsButton.height))
        storeContainer.zPosition = 1
        storeContainer.position.y = -infoButton.height/2
        menuCropper.addChild(storeContainer)
        
        let title = SKLabelNode(fontNamed: "Silkscreen")
        title.zPosition = 1
        title.text = "STORE"
        title.setScale(2/10)
        title.fontSize = 80
        title.fontColor = SKColor.whiteColor()
        title.verticalAlignmentMode = .Center
        title.position.y = storeContainer.currentHeight/2 - 10
        storeContainer.addChild(title)

        
    }
    
    func toggleTopButton(toToggle: SKPixelToggleButtonNode!) {
        let topButtons = [settingsButton, infoButton, IAPButton]
        for button in topButtons {
            if button.enabled && button != toToggle {
                button.disable()
            }
        }
        if toToggle.enabled == false { // enabling currently
            openTopButtonBackground()
        } else { // disabling currently
            print("hide")
            closeTopButtonBackground()
        }
    }
    
    func openTopButtonBackground() {
        topbuttonPanelBG.removeAllActions()
        if topbuttonPanelBG.position.y != 0 {
            let display = SKAction.moveByX(0, y: -bgpanel.currentHeight, duration: 0.25)
            topbuttonPanelBG.runAction(display)
            storeContainer.runAction(display)
        }
        
    }
    
    func closeTopButtonBackground() {
        topbuttonPanelBG.removeAllActions()
        if topbuttonPanelBG.position.y != bgpanel.currentHeight-infoButton.height {
            let hide = SKAction.moveByX(0, y: bgpanel.currentHeight, duration: 0.25)
            topbuttonPanelBG.runAction(hide)
            storeContainer.runAction(hide)
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
    }
}
