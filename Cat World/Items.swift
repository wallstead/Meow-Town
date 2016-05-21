//
//  Item.swift
//  Cat World
//
//  Created by Willis Allstead on 5/20/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class Items: SKNode {
    
    var itemPanel: SKPixelSpriteNode
    let hud: HUD
    var isOpen: Bool
    
    init(inHUD hud: HUD) {
        self.hud = hud
        
        isOpen = false
        
        itemPanel = SKPixelSpriteNode(textureName: "topbar_itempanel", pressAction: {})
        itemPanel.setScale(46/18)
        itemPanel.zPosition = 900
        itemPanel.position.y = hud.topBar.frame.minY+(itemPanel.frame.height/2)
        
        super.init()
        
        self.addChild(itemPanel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggle() {
        if hud.menu!.isOpen {
            hud.menu!.close()
        }
        
        if isOpen {
            close()
        } else {
            open()
        }
    }
    
    func open() {
        itemPanel.runAction(SKAction.moveTo(CGPoint(x: itemPanel.position.x, y: hud.topBar.frame.minY-(itemPanel.frame.height/2)), duration: 0.1), completion: {
            self.isOpen = true
            self.hud.hudIsAnimating = false
        })
    }
    
    func close() {
        itemPanel.runAction(SKAction.moveTo(CGPoint(x: itemPanel.position.x, y: hud.topBar.frame.minY+(itemPanel.frame.height/2)), duration: 0.1), completion: {
            self.isOpen = false
            self.hud.hudIsAnimating = false
        })
    }
}