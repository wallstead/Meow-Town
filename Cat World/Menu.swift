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
        bgpanel.zPosition = 0
        self.addChild(bgpanel)
        
        let settingsButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_settingsbutton")
        settingsButton.zPosition = 1
        settingsButton.position.x = -bgpanel.width/2+settingsButton.frame.width/2
        settingsButton.position.y = bgpanel.height/2-settingsButton.frame.height/2
        bgpanel.addChild(settingsButton)
        
        let infoButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_infobutton")
        infoButton.zPosition = 1
        infoButton.position.x = 0
        infoButton.position.y = bgpanel.height/2-infoButton.frame.height/2
        bgpanel.addChild(infoButton)
        
        let IAPButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_iapbutton")
        IAPButton.zPosition = 1
        IAPButton.position.x = bgpanel.width/2-IAPButton.frame.width/2
        IAPButton.position.y = bgpanel.height/2-IAPButton.frame.height/2
        bgpanel.addChild(IAPButton)
        
        bgpanel.setScale(camFrame.width/bgpanel.width)
        bgpanel.position.y = camFrame.maxY-self.topBar.frame.height+bgpanel.height/2
        
        for i in 0...6 {
            let categoryButton = SKPixelToggleButtonNode(textureName: "topbar_menupanel_itemcategory")
            categoryButton.zPosition = 1
            categoryButton.position.x = 0
            categoryButton.position.y = infoButton.position.y - 33 - 34*CGFloat(i)
            bgpanel.addChild(categoryButton)
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
