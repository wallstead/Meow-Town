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
    var bgpanel: SKPixelSpriteNode!
    var settingsButton: SKPixelToggleButtonNode!
    var infoButton: SKPixelToggleButtonNode!
    var IAPButton: SKPixelToggleButtonNode!
    var topbuttonPanelBG: SKPixelSpriteNode!
    
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
        
        
        settingsButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_settingsbutton")
        settingsButton.zPosition = 2
        settingsButton.position.x = -bgpanel.currentWidth/2+settingsButton.width/2
        settingsButton.position.y = bgpanel.currentHeight/2-settingsButton.height/2
        settingsButton.action = {
            self.toggleTopButton(self.settingsButton)
        }
        bgpanel.addChild(settingsButton)
        
        infoButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_infobutton")
        infoButton.zPosition = 2
        infoButton.position.x = 0
        infoButton.position.y = bgpanel.currentHeight/2-infoButton.height/2
        infoButton.action = {
            self.toggleTopButton(self.infoButton)
        }
        bgpanel.addChild(infoButton)
        
        IAPButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_iapbutton")
        IAPButton.zPosition = 2
        IAPButton.position.x = bgpanel.currentWidth/2-IAPButton.width/2
        IAPButton.position.y = bgpanel.currentHeight/2-IAPButton.height/2
        IAPButton.action = {
            self.toggleTopButton(self.IAPButton)
        }
        bgpanel.addChild(IAPButton)
        
        topbuttonPanelBG = SKPixelSpriteNode(textureName: "topbar_menupanel")
        topbuttonPanelBG.color = DynamicColor(red: 0/255, green: 187/255, blue: 125/255, alpha: 1)
        topbuttonPanelBG.colorBlendFactor = 1
        topbuttonPanelBG.zPosition = 1
        topbuttonPanelBG.position.y = bgpanel.currentHeight-infoButton.height
        bgpanel.addChild(topbuttonPanelBG)
        
//        for i in 0...6 {
//            let categoryButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_itemcategory")
//            categoryButton.zPosition = 1
//            categoryButton.position.x = 0
//            categoryButton.position.y = infoButton.position.y - 33 - 34*CGFloat(i)
//            bgpanel.addChild(categoryButton)
//        }
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
            let display = SKAction.moveToY(0, duration: 0.25)
            topbuttonPanelBG.runAction(display)
        }
        
    }
    
    func closeTopButtonBackground() {
        topbuttonPanelBG.removeAllActions()
        if topbuttonPanelBG.position.y != bgpanel.currentHeight-infoButton.height {
            let hide = SKAction.moveToY(bgpanel.currentHeight-infoButton.height, duration: 0.25)
            topbuttonPanelBG.runAction(hide)
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
