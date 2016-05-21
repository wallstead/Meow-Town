//
//  MenuPanel.swift
//  Cat World
//
//  Created by Willis Allstead on 5/20/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class Menu: SKNode {
    
    var menuPanel: SKPixelSpriteNode
    let hud: HUD
    var isOpen: Bool
    
    init(inHUD hud: HUD) {
        self.hud = hud
        
        isOpen = false
        
        menuPanel = SKPixelSpriteNode(textureName: "topbar_menupanel", pressAction: {})
        menuPanel.setScale(46/18)
        menuPanel.zPosition = 901
        menuPanel.position.y = hud.topBar.frame.minY+(menuPanel.frame.height/2)
        
        super.init()
        
        let settingsButton = SKPixelButtonNode(buttonImage: "topbar_menupanel_settingsbutton", buttonText: nil, buttonAction: {
            print("settings")
        })
        settingsButton.zPosition = 1
        settingsButton.position = convertPoint(CGPoint(x: menuPanel.frame.minX,
                                                       y: menuPanel.frame.maxY), toNode: menuPanel)
        settingsButton.position.x += settingsButton.frame.width/2
        settingsButton.position.y -= settingsButton.frame.height/2
        
        self.addChild(menuPanel)
        menuPanel.addChild(settingsButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggle() {
        if hud.items!.isOpen {
            hud.items!.close()
        }
        
        if isOpen {
            close()
        } else {
            open()
        }
    }
    
    func open() {
        menuPanel.runAction(SKAction.moveTo(CGPoint(x: menuPanel.position.x, y: hud.topBar.frame.minY-(menuPanel.frame.height/2)), duration: 0.25), completion: {
            self.isOpen = true
            self.hud.hudIsAnimating = false
        })
    }
    
    func close() {
        menuPanel.runAction(SKAction.moveTo(CGPoint(x: menuPanel.position.x, y: hud.topBar.frame.minY+(menuPanel.frame.height/2)), duration: 0.25), completion: {
            self.isOpen = false
            self.hud.hudIsAnimating = false
        })
    }
}