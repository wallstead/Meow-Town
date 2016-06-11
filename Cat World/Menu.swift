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
        bgpanel.position.y = camFrame.maxY-self.topBar.frame.height
        bgpanel.anchorPoint = CGPoint(x: 0.5, y: 0)
        bgpanel.setScale(camFrame.width/bgpanel.width)
        bgpanel.zPosition = 0
        self.addChild(bgpanel)
        
        print("test from menu")
//        open()
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
        bgpanel.runAction(dropPanelToY(camFrame.minY, duration: 1), completion: {
            
        })
    }
    
    func close() {
        self.isOpen = false
        bgpanel.runAction(dropPanelToY(camFrame.maxY-self.topBar.frame.height, duration: 1), completion: {
            
        })
    }

}
